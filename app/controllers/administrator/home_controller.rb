class Administrator::HomeController < ApplicationController
  layout :resolve_layout

  def index
    @rolling = {
      students: Student.count,
      teachers: Teacher.count,
      klasses: Klass.count,
      sections: Section.count,
    }
  end

  def lock_account
    session[:lock_account] = true
  end

  def unlock_account
    if current_user.valid_password?(params[:password])
      flash[:notice] = 'Successfully unlocked your account!'
    else
      flash[:alert] = 'You entered incorrect password!'
    end

    redirect_to root_path
  end

  private
    def resolve_layout
      case action_name
        when 'lock_account'
          'empty'
        else
          'application'
      end
    end
end
