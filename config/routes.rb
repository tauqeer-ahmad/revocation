require 'api_version'
Revocation::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

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
    end

  end

  namespace :admin do
    devise_for :supervisors, controllers: {
      sessions: 'sessions'
    }
  end

  authenticated :admin_supervisor do
    root to: 'admin/home#index'
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
    root to: 'administrator/home#index', as: :administrator_root
    get :configuration, to: 'administrator/home#configuration'
    post :save_configuration, to: 'administrator/home#save_configuration'
    get :lock_account, to: 'administrator/home#lock_account'
    post :unlock_account, to: 'administrator/home#unlock_account'

    namespace :administrator do
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
        end

        resources :sections, only: [:new, :edit, :show, :update, :create, :destroy] do
          collection do
            get :fetch
          end
          member do
            get :update_subjects
          end
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
        resources :timetables, only: [:index, :edit, :create, :update, :destroy]
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
      end

      resource :pin_board, controller: :pin_board, only: [:show, :create, :update, :destroy]

      resources :exams do
        collection do
          get :autocomplete
        end
        resources :exam_timetables, only: [:index, :edit, :update, :create, :destroy]
      end

      resources :marksheets, only: [:index, :edit, :destroy]do
        collection do
          get :existing
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
    scope module: :teacher do
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
        end
      end

      resources :assignments, only: [:new, :edit, :create, :update, :destroy] do
        collection do
          get '/list/:section_id/:subject_id', to: 'assignments#index'
        end
      end

      resources :question_papers
    end
  end

  authenticated :student do
    scope module: :student do
      root to: 'home#index'

      resource :attendance, controller: :attendance, only: [] do
        get :report
      end
      resources :assignments, only: [:index]
    end
  end

  authenticated :guardian do
    scope module: :guardian do
      root to: 'home#index'

      post :select_student, to: 'home#select_student'

      resource :attendance, controller: :attendance, only: [] do
        get :report
      end
      resources :assignments, only: [:index]
    end
  end

  resources :testimonials, only: [:index, :create, :update, :destroy]

  post :contact_us, to: 'home#contact_us'
  root to: 'home#index'
end
