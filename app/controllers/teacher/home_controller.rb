class Teacher::HomeController < ApplicationController
  layout 'empty', only: [:lock_account]

  def index
  end

  def lock_account
    session[:lock_account] = true
  end

  def unlock_account
    if current_user.valid_password?(params[:password])
      session[:lock_account] = false
      flash[:notice] = 'Successfully unlocked your account!'
    else
      flash[:alert] = 'You entered incorrect password!'
    end

    redirect_to root_path
  end

  def global_search
    @results = Teacher.search(params['global_search'], index_name: current_user.global_search_models)
  end
end
