Rails.application.routes.draw do

  post 'notification', to: 'notification#create'
  post 'validate_qrcode', to: 'chopps#validate_qrcode'
  post 'checkout/create'
  
  resources :users
  
  post 'authenticate', to: 'authentication#authenticate'  
  get 'getsessionid', to: 'checkout#generate_session_token'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
