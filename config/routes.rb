Rails.application.routes.draw do
  get 'map/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :trips do
    resources :participants
    resources :map
  end

  devise_for :users, :controllers => { registrations: 'registrations' }

  get '/dashboard', to: 'dashboard#index', as: 'dashboard'

  get 'search', to: 'trips#search', as: 'search'

end
