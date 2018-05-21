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

  def configuration
    @institution = Institution.current
  end

  def save_configuration
    @institution = Institution.current

    if @institution.update(institution_params)
      redirect_to configuration_path, notice: 'Successfully updated Institution'
    else
      redirect_to configuration_path, alert: @institution.errors.to_sentence
    end
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

  def validate_field
    record = params[:model].constantize.new("#{params[:attribute]}": params[:value])
    record.validate_attribute(params[:attribute], params[:value])
    render json: { message: record.errors["#{params[:attribute]}"].to_sentence }
  end

  def global_search
    @results = Searchkick.search(params['global_search'], index_name: current_user.global_search_models, match: :word_start, operator: "or")
  end

  private
    def institution_params
      params.require(:institution).permit(:logo, :email, :phone_number, :fax_number, :address, :contact_description, :facebook_url, :twitter_url, :linkedin_url, :video_url, :latitude, :longitude)
    end

    def resolve_layout
      case action_name
        when 'lock_account'
          'empty'
        else
          'application'
      end
    end
end
