Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  root to: 'study_times#index'
  resources :cheer_messages
	resources :study_times
  resources :rankings
  resource :profile,only: [:show, :edit, :update]
end
