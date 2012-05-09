Coursetown::Application.routes.draw do
  get "schedule/index"

  resources :users

  get "planner" => "planner#show"

  resources :offerings

  resources :courses
  resources :professors

  resources :wishlists

  resources :schedules

  root :to => "splash#index"

  match "/search" => "offerings#search", :as => :search
  match "/search_json" => "offerings#search_results", :as => :search_json

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  resources :reviews, :except => [:index, :new] do
    # aggregate pages
    collection do
      get 'prof/:id' => 'reviews#prof', :as => :prof
      get 'offering/:id' => 'reviews#offering', :as => :offering
      get 'offering/:id/new' => 'reviews#new', :as => :new
      get 'course/:id' => 'reviews#course', :as => :course

      post 'batch_from_transcript' => 'reviews#new_batch_from_transcript', :as => :from_transcript

      get 'batch' => 'reviews#new_batch', :as => :new_batch
      post 'batch' => 'reviews#create_batch', :as => :create_batch

      get 'batch_start' => 'reviews#batch_start', :as => :batch_start
    end
  end

end
