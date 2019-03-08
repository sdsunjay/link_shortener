Rails.application.routes.draw do
  namespace :admin do
      resources :shorten_urls
      resources :url_clicks

      root to: "users#index"
  end
  resources :shorten_urls, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  resources :url_clicks, only: [:new, :create, :index, :show, :edit, :update]
  # custom 404
  match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ]
  get '/:short_url', to: 'shorten_urls#send_to_url'
  get '/s/admin/:admin_url', to: 'shorten_urls#admin_send_to_url'
  root to: 'shorten_urls#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
