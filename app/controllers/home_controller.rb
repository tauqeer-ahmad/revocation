class HomeController < ApplicationController
  before_action :set_institution
  layout 'splash'

  def index
  end

  def contact_us
    CustomerMailer.contact_us(@institution.try(:email), params[:email], params[:contact_number], params[:subject], params[:message]).deliver!
    redirect_to root_path, notice: 'Your email has been sent. We will contact you soon.'
  end

  private
    def set_institution
      @institution = request.subdomain.present? && Institution.current
    end
end
