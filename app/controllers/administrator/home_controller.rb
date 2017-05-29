class Administrator::HomeController < ApplicationController
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
      redirect_to configuration_path, alert: 'Something went wrong.'
    end
  end

  private
    def institution_params
      params.require(:institution).permit(:logo, :email, :phone_number, :fax_number, :address, :contact_description, :facebook_url, :twitter_url, :linkedin_url, :video_url, :latitude, :longitude)
    end
end
