Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Set the root path to the surveys index
  root "surveys#index"
  
  # RESTful routes for surveys
  resources :surveys do
    # Nested routes for questions
    resources :questions
    
    # Nested routes for survey variations
    resources :survey_variations, only: [:create, :index, :show, :update, :destroy]

    # Route for taking a survey
    member do
      get 'take'
      post 'submit'
    end
  end
  
  # Route for creating responses
  resources :responses, only: [:create]
end
