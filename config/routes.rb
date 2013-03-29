Birthday::Application.routes.draw do
  root  :to => "home#index"
  resources :facebook_users do
    collection { get :login }
  end
  resources :home
end