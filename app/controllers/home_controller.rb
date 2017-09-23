class HomeController < ApplicationController
  before_action :set_institution
  layout 'splash'

  def index
    @remarks = Remark.active.order('Random()').limit(Remark::LIMIT_FOR_LANDING)
  end

  def contact_us
    if params[:email].present? && params[:subject].present? && params[:message].present?
      CustomerMailer.contact_us(@institution.try(:email), params[:email], params[:contact_number], params[:subject], params[:message]).deliver!
      flash[:notice] = 'Your email has been sent. We will contact you soon.'
    else
      flash[:alert] = 'Youd did not provide required information.'
    end

    redirect_to root_path
  end

  private
    def set_institution
      @institution = request.subdomain.present? && Institution.current
    end
end
