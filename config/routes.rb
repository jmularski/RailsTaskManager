Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :authentication do
    post 'signup', to: 'authentication#signup', as: 'signup'
    post 'signin', to: 'authentication#signin', as: 'signin'
    post "send_reset_password", to: "authentication#send_reset_password", as: "send_reset_password"
    post "reset_password", to: "authentication#reset_password", as: "reset_password"
  end
end
