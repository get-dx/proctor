Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Set the root path to the surveys index
  root "surveys#index"
  
  resources :roles do
    member do
      patch 'restore'
    end
    collection do
      get 'deleted'
    end
  end
  
  resources :surveys do
    # Nested routes for questions
    resources :questions, except: [:show] do
      member do
        patch 'restore'
      end
    end
    get 'analytics', to: 'branch_analytics#show'
    # Route for taking a survey
    member do
      patch 'restore'
      get 'take'
      post 'submit'
    end
    # Route for creating responses
    resources :responses, only: [:create]
  end
end
