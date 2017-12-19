Rails.application.routes.draw do
  root 'welcome#index'

  get '/app', to: 'shopify_challenge#index'
  post '/app', to: 'shopify_challenge#create'
end
