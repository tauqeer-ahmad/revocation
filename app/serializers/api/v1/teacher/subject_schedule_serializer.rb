module Api
  module V1
    module Teacher
      class SubjectScheduleSerializer < ActiveModel::Serializer
        attributes :id, :content

        belongs_to :subject
        belongs_to :section
        belongs_to :klass
      end
    end
  end
end
