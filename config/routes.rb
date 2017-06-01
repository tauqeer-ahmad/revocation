Revocation::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  namespace :admin do
    devise_for :supervisors, :controllers => {
      :sessions => 'sessions'
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

    namespace :administrator do
      resources :teachers do
        collection do
          post :bulk_insert
        end
      end

      resources :guardians do
        collection do
          get :fetch
        end
      end

      resources :klasses, path: :classes do
        collection do
          post :bulk_insert
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
        end
      end

      resources :terms do
        member do
          put :update_selected_term
        end
      end

      resources :sections, only: [:index] do
        resources :timetables
        resources :students do
          collection do
            get :bulk_view
            post :bulk_insert
          end
        end
      end

      resource :pin_board, controller: :pin_board, only: [] do
        collection do
          get :landing
          post :create_note
          delete :delete_note
        end
      end

      resources :exams do
        resources :exam_timetables
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

      resources :sections, only: [:index]
      resources :assignments
    end
  end

  authenticated :student do
    root to: 'home#index'
  end

  authenticated :parent do
    root to: 'home#index'
  end

  root to: 'home#index'
end
