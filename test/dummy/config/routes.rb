Rails.application.routes.draw do

  mount Fbsync::Engine => "/fbsync"
end
