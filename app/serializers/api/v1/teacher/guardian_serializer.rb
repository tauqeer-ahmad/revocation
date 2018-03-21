module Api
  module V1
    module Teacher
      class GuardianSerializer < ActiveModel::Serializer
        attributes :id, :name, :email, :phone, :avatar_url, :thumb_avatar_url, :medium_avatar_url

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
