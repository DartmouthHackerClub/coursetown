Coursetown::Application.routes.draw do
  # get "schedule/index"

  # resources :users

  # get "planner" => "planner#show"

  # resources :offerings

  resources :courses, :only => :index
  resources :professors, :only => :index
  resources :departments, :only => :index

  # resources :wishlists

  # resources :schedules

  root :to => "splash#index"

  match "/am_i_logged_in" => 'users#am_i_logged_in', :as => :am_i_logged_in

  match "/search" => "offerings#search", :as => :search
  match "/search_json" => "offerings#search_results", :as => :search_json

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  get "/old_reviews/:id" => 'reviews#show_old_review', :as => :old_review

  resources :reviews, :only => [:show, :create, :update, :edit] do
    # aggregate pages
    collection do
      get 'prof/:id' => 'reviews#prof', :as => :prof
      # get 'offering/:id' => 'reviews#offering', :as => :offering
      get 'course/:id/new' => 'reviews#new', :as => :new
      get 'course/:id' => 'reviews#course', :as => :course
      post 'course/:id' => 'reviews#create', :as => :update

      get 'quick_start' => 'reviews#batch_start', :as => :quick_start
      post 'from_transcript' => 'reviews#new_batch_from_transcript', :as => :from_transcript
      post 'batch' => 'reviews#create_batch', :as => :create_batch

      # get 'batch' => 'reviews#new_batch', :as => :new_batch
    end
  end

end
