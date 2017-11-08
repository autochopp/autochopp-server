Rails.application.routes.draw do

  post 'notification', to: 'notification#create'
  post 'validate_qrcode', to: 'chopps#validate_qrcode'
  post 'checkout/create'
  post 'setsensors', to: 'sensors#set_sensors_values' 
  get 'getsensors', to: 'sensors#get_sensors_values' 
  get  'getchopps', to: 'chopps#index'
  
  resources :users
  
  post 'authenticate', to: 'authentication#authenticate'  
  get 'getsessionid', to: 'checkout#generate_session_token'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
