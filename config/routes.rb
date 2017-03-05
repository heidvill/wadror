Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beer_clubs do
    post 'toggle_confirmation', on: :member
  end
  resources :users do
    post 'toggle_suspension', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy] # Huom! resource yksikkömuodossa vrt. muihin
  resources :places, only: [:index, :show]
  # yo. generoi samat polut kuin seuraavat kaksi
  # get 'places', to:'places#index'
  # get 'places/:id', to:'places#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'breweries#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  post 'places', to: 'places#search'

  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'

end

