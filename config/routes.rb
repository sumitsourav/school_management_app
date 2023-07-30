# config/routes.rb

Rails.application.routes.draw do
  devise_for :users

  # Users routes
  post 'users/create_school_admin', to: 'users#create_school_admin', as: :create_school_admin
  get 'users/new_school_admin', to: 'users#new_school_admin', as: :new_school_admin
  get 'users/school_admin_section', to: 'users#school_admin_section', as: :school_admin_section
  resources :users do
    collection do
      get :list_school_admins
    end
  end

  # Schools routes
  resources :schools do
    # Courses routes nested under schools
    resources :courses do
      # Batches routes nested under courses
      resources :batches do
        # Students routes nested under batches
        resources :students
        resources :enrollments, only: [:new, :create, :index]
      end
    end
  end
  post 'enrollments/:id/approval', to: 'enrollments#approval', as: :approval_enrollment
  post 'enrollments/:id/decline', to: 'enrollments#decline', as: :decline_enrollment
  # Home page or root path (you can change it to the desired path)
  authenticated :user do
    root to: 'home#index', as: :authenticated_root
  end
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
end
