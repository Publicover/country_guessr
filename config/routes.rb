Rails.application.routes.draw do
  namespace :api do 
    namespace :v1 do 
      post 'auth/login', to: 'authentications#authenticate'
    end
  end
end
