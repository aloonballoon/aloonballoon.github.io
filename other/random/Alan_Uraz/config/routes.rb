Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

resources :users 
resources :products do 
  resources :comments, only: [:create]
end
resources :comments, except: [:create]
resource :session


end
