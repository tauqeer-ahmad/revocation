class TestimonialsController < ApplicationController
  def index
    @testimonials = Testimonial.includes(:user).all
  end

  def create
    current_user.testimonials.create(testimonial_params)
    redirect_back fallback_location: root_path, notice: 'Feedback has been submitted successfully.'
  end

  def update
    Testimonial.find(params[:id]).update(status: params[:status])
    redirect_back fallback_location: root_path, notice: 'Testimonial has been updated successfully.'
  end

  def destroy
    Testimonial.find(params[:id]).destroy
    redirect_back fallback_location: root_path, notice: 'Testimonial has been deleted successfully.'
  end

  private
    def testimonial_params
      params.require(:testimonial).permit(:heading, :message)
    end
end
