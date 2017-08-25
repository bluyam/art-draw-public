Rails.application.routes.draw do
  resources :canvas_states
  get 'games/archive'
  resources :games
  resources :authentications
  root 'page#home'
  post 'game/create' => "game#create"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", registrations: 'registrations'  }
end
