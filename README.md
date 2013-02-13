# Fbsync

This gem is a simple Rails lib to enable easy fetching of Facebook data, assuming you need to run some background job that synchronizes some facebook account with your app data.

This is clearly meant to cover the following case :
* You have one facebook account to synchronize your app (website) with
* You must fetch data from facebook and be warned when your admin's token is expired or will expire soon, so the admin can refresh it manually
* You want to use [FbGraph](https://github.com/nov/fb_graph) to work with Facebook's API

## Installation

Add the gem to your app's `Gemfile` and `bundle install` :

```ruby
gem "fbsync"
```

Run the install generator to get migrations and initializer in your app, and migrate :

```bash
rails generate fbsync:install
rake db:migrate
```

## Using the Fbsync::Token model

### Basics

The `Token` model is meant to be a container for your token.
The idea behind it is to feed it a short-lived token and when you save the model
it fetches a long-lived token from Facebook's API and store it.

The way you get the short-lived token doesn't matter.
For instance, say you signed in you user from facebook through omniauth,
you can do the following in your omniauth callback :

```ruby
class OmniauthCallbacksController
  def facebook
    token = FbSync::Token.create(value: request.env["omniauth.auth"].credentials.token)
    # Here the Token instance is saved with a long-lived token contained in #value
    # so you can use it to query Facebook API for 2 months
  end
end
```

### Associate a user to a token

The Fbsync::Token model is ready to be associated to a `token_owner`,
say a `User` model through a polymorphic association :

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_one :token, as: :token_owner, class_name: 'Fbsync::Token'
end
```

Then in your omniauth callback you can store it as the following :

```ruby
class OmniauthCallbacksController
  def facebook
    current_user.create_token FbSync::Token.create(value: request.env["omniauth.auth"].credentials.token)
    # You can now access your token with `current_user.token`
  end
end
```

## Defining a default method to fetch a token

If you don't want to manually fetch the token in your tasks and
you only have one admin with a token, you can set the following property in the
fbsync initializer :

```ruby
Fbsync.config do |config|
  config.token_fetch_method = lambda {
    # Here we assume you have a single admin with an associated token
    User.includes(:token).where('admin = ? AND fbsync_tokens.id NOT NULL', true).first.token
  }
end
```

## Using the Fbsync::Sync#run method

The goal of all this configuration, is to allow you to run operations with a
long-lived token and warn the admin of a posible expiration of his token.

Say you want to run some job with a Rake task, you could do the following :

```ruby
namespace :facebook do
  task fetch_albums: :environment do
    FbSync::Sync.run do |token|
      # Use the long-lived token here
    end
  end
end
```
