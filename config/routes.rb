Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :trips

  devise_for :users, :controllers => { registrations: 'registrations' }

  get '/dashboard', to: 'dashboard#index', as: 'dashboard'

  get 'search', to: 'trips#search', as: 'search'

end
