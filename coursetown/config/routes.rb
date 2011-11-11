Coursetown::Application.routes.draw do
  get "schedule/index"

  resources :users

  get "planner" => "planner#show"

  resources :offerings

  resources :courses

  resources :wishlists

  resources :schedules

  root :to => "splash#index"

  match "/search" => "offerings#search"
  match "/search_json" => "offerings#search_results"

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

end
