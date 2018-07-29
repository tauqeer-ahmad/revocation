module Api
  module V1
    module Student
      class NoticeSerializer < ActiveModel::Serializer
        attributes :title, :message, :notice_type

        belongs_to :klass
        belongs_to :section
      end
    end
  end
end
