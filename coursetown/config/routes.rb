Coursetown::Application.routes.draw do
  get "schedule/index"

  resources :users

  get "planner" => "planner#show"

  resources :offerings

  resources :courses

  resources :wishlists

  resources :schedules

  root :to => "splash#index"

  match "/search" => "offerings#search", :as => :search
  match "/search_json" => "offerings#search_results", :as => :search_json

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  resources :reviews, :except => :index do
    # aggregate pages
    collection do
      get 'prof/:id' => 'reviews#prof', :as => :prof
      get 'course/:course_id/prof/:prof_id' => 'reviews#course_prof', :as => :course_prof
      get 'course/:id' => 'reviews#course', :as => :course

      get 'new_batch'
    end
  end

end
