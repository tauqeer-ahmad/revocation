require 'api_version'
Revocation::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  resources :conversations, only: [:index, :show] do
    resources :messages

    collection do
      get :fetch
    end
  end

  namespace :api, constraints: { format: 'json' } do
    scope module: :v1, constraints: ApiVersion.new(version: 'v1', default: true) do
      scope module: :devise do
        devise_for :students, skip: [:sessions]
        as :student do
          post 'students/login', to: 'sessions#create'
          delete 'students/logout', to: 'sessions#destroy'
        end

        devise_for :teachers, skip: [:sessions]
        as :teacher do
          post 'teachers/login', to: 'sessions#create'
          delete 'teachers/logout', to: 'sessions#destroy'
        end

        devise_for :guardians, skip: [:sessions]
        as :guardian do
          post 'guardians/login', to: 'sessions#create'
          delete 'guardians/logout', to: 'sessions#destroy'
        end
      end

      namespace :student do
        resources :exams, only: [:index, :show] do
          member do
            get :results
          end
        end
        resources :timetables, only: [:index]
        resources :attendances, only: [:index]
        resources :assignments, only: [:index, :show]
      end

      namespace :guardian do
        resources :exams, only: [:index, :show] do
          member do
            get :results
          end
        end
        resources :timetables, only: [:index]
        resources :students, only: [:index]
        resources :attendances, only: [:index]
        resources :assignments, only: [:index, :show]
      end

      namespace :teacher do
        resources :sections, only: :index
        resources :attendance_sheets, only: :index
        resources :attendances, only: :index
        resources :assignments, only: [:index, :show]
      end
    end
  end

  namespace :admin do
    devise_for :supervisors, controllers: {
      sessions: 'sessions'
    }
  end

  authenticated :admin_supervisor do
    root to: 'admin/home#index'

    resource :pin_board, controller: :pin_board, only: [:show, :create, :update, :destroy]
    resources :remarks, only: [:index, :update, :destroy]

    namespace :admin do
      resources :institutions do
        resources :administrators
      end
    end
  end

  devise_for :administrator, :controllers => {
    :sessions => 'sessions'
  }

  devise_for :teachers, :controllers => {
    :sessions => 'sessions'
  }

  devise_for :students, :controllers => {
    :sessions => 'sessions'
  }

  devise_for :guardians, :controllers => {
    :sessions => 'sessions'
  }

  authenticated :administrator do
    resource :pin_board, controller: :pin_board, only: [:show, :create, :update, :destroy]

    root to: 'administrator/home#index', as: :administrator_root
    get :configuration, to: 'administrator/home#configuration'
    post :save_configuration, to: 'administrator/home#save_configuration'
    get :lock_account, to: 'administrator/home#lock_account'
    post :unlock_account, to: 'administrator/home#unlock_account'
    post :validate_field, to: 'administrator/home#validate_field'
    get :global_search, to: 'administrator/home#global_search'

    resources :testimonials, only: [:index, :update, :destroy]
    resources :remarks, only: [:create]

    resources :administrators, only: [:index], constraints: { format: /html/ }

    namespace :administrator do
      resources :grading_systems do
        member do
          post :move
        end
      end
      resources :grades, only: [] do
        member do
          post :move
        end
      end
      resources :admissions, only: [:index, :new]
      resources :teachers do
        collection do
          post :bulk_insert
          get :autocomplete
        end
      end

      resources :guardians do
        collection do
          get :fetch
          get :autocomplete
        end
      end

      resources :klasses, path: :classes do
        collection do
          post :bulk_insert
          get :autocomplete
        end
        member do
          get :update_sections
          post :move
        end

        resources :sections, only: [:new, :edit, :show, :update, :create, :destroy] do
          collection do
            get :fetch
          end
          member do
            get :update_subjects
            get :update_exams
          end
        end
      end

      resources :notices, except: [:new, :show] do
        collection do
          get :autocomplete
        end
      end

      resources :subjects do
        collection do
          post :bulk_insert
          get :autocomplete
        end
      end

      resources :terms do
        member do
          put :update_selected_term
        end
      end

      resources :sections, only: [:index] do
        resources :timetables, only: [:index, :new, :edit, :create, :update, :destroy] do
          collection do
            get :bulk
            post :bulk_create
          end
        end
        resources :students do
          collection do
            get :bulk_view
            post :bulk_insert
            get :autocomplete
          end
          member do
            put :update_section
          end
        end
      end
      resources :students, only: [] do
        member do
          get :results
        end

        collection do
          get :lookup
        end
      end

      resource :pin_board, controller: :pin_board, only: [:show, :create, :update, :destroy]

      resources :exams do
        collection do
          get :autocomplete
        end
        member do
          post :status_update
        end
        resources :exam_timetables do
          collection do
            post :bulk_create
            get :bulk
          end
        end
      end

      resources :marksheets, only: [:index, :edit, :destroy]do
        collection do
          get :build_marksheet
          post :create_marksheet
          get :generate_tabulation_sheet
          get :tabulation_sheet
        end
        member do
          put :update_marksheet
        end
      end

      resources :attendance_sheets, only: [:index, :update, :destroy] do
        collection do
          get :teachers
          get :managing_teachers
          get :managing_students
        end
      end

      resources :student_promotions, only: [:index, :create] do
        collection do
          get :list_students
        end
      end
    end
  end

  authenticated :teacher do
    resources :testimonials, only: [:create]
    resource :pin_board, controller: :pin_board, only: [:show, :create, :update, :destroy]

    scope module: :teacher do
      get :lock_account, to: 'home#lock_account'
      post :unlock_account, to: 'home#unlock_account'
      get :global_search, to: 'home#global_search'
      root to: 'home#index'

      resources :attendance_sheets, only: [:index, :update, :destroy] do
        collection do
          get :managing_students
        end
      end

      resources :sections, only: [:index] do
        collection do
          get :update_sections
        end
        member do
          get :update_subjects
          get :update_exams
        end
      end

      resources :assignments, only: [:new, :edit, :create, :update, :destroy, :show] do
        collection do
          get '/list/:section_id/:subject_id', to: 'assignments#index', as: 'list'
        end

        member do
          post :status_update
        end
      end

      resources :question_papers
      resources :subject_schedules

      resources :notices, only: :index do
        collection do
          get :autocomplete
        end
      end

      resources :terms, only: :index do
        member do
          put :update_selected_term
        end
      end
    end
  end

  authenticated :student do
    resources :testimonials, only: [:create]
    resource :pin_board, controller: :pin_board, only: [:show, :create, :update, :destroy]

    scope module: :student do
      get :lock_account, to: 'home#lock_account'
      post :unlock_account, to: 'home#unlock_account'
      root to: 'home#index'

      resource :attendance, controller: :attendance, only: [] do
        get :report
      end
      resources :assignments, only: [:index, :show]
      resources :results, only: [:index]
      resources :timetables, only: [:index], as: :class_routine, path: :class_routine
      resources :exams do
        collection do
          get :autocomplete
        end
      end

      resources :notices, only: :index do
        collection do
          get :autocomplete
        end
      end
    end
  end

  authenticated :guardian do
    resources :testimonials, only: [:create]
    resource :pin_board, controller: :pin_board, only: [:show, :create, :update, :destroy]

    scope module: :guardian do
      get :lock_account, to: 'home#lock_account'
      post :unlock_account, to: 'home#unlock_account'
      root to: 'home#index'

      post :select_student, to: 'home#select_student'

      resource :attendance, controller: :attendance, only: [] do
        get :report
      end
      resources :assignments, only: [:index, :show]

      resources :exams do
        collection do
          get :autocomplete
        end
      end

      resources :notices, only: :index do
        collection do
          get :autocomplete
        end
      end
    end
  end

  resource :account, only: [:show, :update] do
    member do
      put :update_password
    end
  end
  post :contact_us, to: 'home#contact_us'
  root to: 'home#index'

  get '/404', to: 'error#not_found'
  get '/500', to: 'error#server'

  get '*path', to: 'error#not_found', constraints: { format: /(html|json|js)/ }
end
