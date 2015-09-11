Rails.application.routes.draw do
  namespace :api, path: '/' do
    namespace :v1 do
      resources :asset, except: [:new, :edit]

      resources :variant, except: [:new, :edit]
    end
  end

  root :to => 'api/v1/variant#index'
end
