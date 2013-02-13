module Fbsync
  class InstallGenerator < Rails::Generators::Base
    # Copied files come from templates folder
    source_root File.expand_path('../templates', __FILE__)

    # Generator desc
    desc "Fbsync install generator"

    def welcome
      do_say "Installing Fbsync data"
    end

    def copy_initializer_file
      do_say "Installing default initializer template"
      copy_file "initializer.rb", "config/initializers/fbsync.rb"
    end

    def copy_migrations
      do_say "Installing migrations, don't forget to migrate"
      rake "fbsync:install:migrations"
    end

    def mount_engine
      mount_path = ask("Where would you like to mount Fbsync engine ? [/fbsync]").presence || '/fbsync'
      gsub_file "config/routes.rb", /^.*mount Fbsync::Engine.*$/, ''
      route "mount Fbsync::Engine => '#{ mount_path }', :as => 'fbsync'"
    end

    private

    def do_say str, color = :green
      say "[ Fbsync ] #{str}", color
    end
  end
end
