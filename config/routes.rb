Revocation::Application.routes.draw do
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
    namespace :administrator do
      root to: 'home#index'
      resources :teachers
      resources :klasses, path: :classes do
        resources :sections, only: [:new, :edit, :show, :update, :create] do
          collection do
            get :fetch
          end
        end
      end
      resources :subjects
      resources :terms
      resources :sections, only: [:index] do
        resources :students
      end
    end
  end
  
  authenticated :teacher do
    scope module: :teacher do
      root to: 'home#index'
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
