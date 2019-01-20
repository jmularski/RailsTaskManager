Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :leader do
    post 'signup', to: 'authentication#signup', as: 'signup'
    post 'signin', to: 'authentication#signin', as: 'signin'
  end
end
