Rails.application.routes.draw do
  resources :users
  post 'authenticate', to: 'authentication#authenticate'
  get 'getsessionid', to: 'checkout#create_payment_session'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
