module Api
  module V1
    module Teacher
      class StudentSerializer < ActiveModel::Serializer
        attributes :id, :name, :roll_number, :registration_number, :email, :phone, :avatar_url, :thumb_avatar_url, :medium_avatar_url

        belongs_to :guardian

        def avatar_url
          object.avatar.url
        end

        def medium_avatar_url
          object.avatar.url(:medium)
        end

        def thumb_avatar_url
          object.avatar.url(:thumb)
        end
      end
    end
  end
end
