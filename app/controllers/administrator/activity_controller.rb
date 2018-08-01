class Administrator::ActivityController < ApplicationController
  def show
    @versions = PaperTrail::Version.includes(:item).order(created_at: :desc)

    user_ids = @versions.map(&:whodunnit).reject(&:blank?).map(&:to_i).uniq
    @users = User.where(id: user_ids)
  end
end
