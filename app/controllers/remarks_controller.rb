class RemarksController < ApplicationController
  def index
    @remarks = Remark.all
  end

  def create
    Remark.create(remark_params)
    redirect_back fallback_location: root_path, notice: 'Feedback has been submitted successfully.'
  end

  def update
    Remark.find(params[:id]).update(status: params[:status])
    redirect_back fallback_location: root_path, notice: 'Remark has been updated successfully.'
  end

  def destroy
    Remark.find(params[:id]).destroy
    redirect_back fallback_location: root_path, notice: 'Remark has been deleted successfully.'
  end

  private
    def remark_params
      params.require(:remark).permit(:heading, :message).tap do |custom_params|
        custom_params[:user_name] = current_user.name
        custom_params[:user_institution] = Institution.current.name
        custom_params[:user_avatar_url] = current_user.avatar.url
      end
    end
end
