module Api
  module V1
    module Student
      class ExamTimetableSerializer < ActiveModel::Serializer
        attributes :id, :start_time, :end_time, :paper_date, :section, :klass, :subject

        def section
          object.section.name
        end

        def subject
          object.subject.name
        end

        def klass
          object.klass.name
        end
      end
    end
  end
end
