module Authentication
  extend ActiveSupport::Concern

  included do
    before_create :generate_access_token!
  end

  module ClassMethods
  end

  def generate_access_token!
    begin
      self.access_token = Devise.friendly_token
    end while self.class.exists?(access_token: access_token)
  end

  def regenerate_access_token
    generate_access_token!
    save
  end

  def invalidate_token
    self.update_columns(access_token: nil)
  end
end
