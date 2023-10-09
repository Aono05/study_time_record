Rails.application.routes.draw do
  devise_for :users
  root to: 'cheer_messages#show'
  get 'study_times/index', to: 'study_times#index'
  resources :cheer_messages
	resources :study_times
  resources :rankings
  resource :profile,only: [:show, :edit, :update]
end
