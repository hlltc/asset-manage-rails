Rails.application.routes.draw do
  namespace :api, path: '/' do
    namespace :v1 do
      resources :variant
    end
  end

  root :to => 'api/v1/variant#index'
end
