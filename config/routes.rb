Rails.application.routes.draw do
  root "adversaries#index"
  resources :adversaries
end
