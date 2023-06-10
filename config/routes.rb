Rails.application.routes.draw do
  devise_for :users
  root to: 'cheer_messages#index'
  get 'study_times/index', to: 'study_times#index'
  resources :study_times
end
