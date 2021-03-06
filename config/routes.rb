Rails.application.routes.draw do
  resources :shorten_urls, only: [:new, :create, :edit, :update, :show, :destroy]
  # custom 404
  match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ]
  match "/401" => "errors#error401", via: [ :get, :post, :patch, :delete ]
  get '/:short_url', to: 'shorten_urls#send_to_url'
  get '/s/admin/:admin_url', to: 'shorten_urls#admin_send_to_url'
  root to: 'shorten_urls#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
