Rails.application.routes.draw do
  root to: 'posts#index'

  resources :posts

  get 'test/middleware', to: 'test#middleware'
  get 'test/url', to: 'test#url'
end
