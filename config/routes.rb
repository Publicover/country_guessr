Rails.application.routes.draw do
  post 'auth/login', to: 'authentications#authenticate'
end
