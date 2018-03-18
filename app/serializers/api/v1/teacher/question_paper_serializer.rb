module Api
  module V1
    module Teacher
      class QuestionPaperSerializer < ActiveModel::Serializer
        attributes :id, :content

        belongs_to :section
        belongs_to :klass
        belongs_to :exam
      end
    end
  end
end
