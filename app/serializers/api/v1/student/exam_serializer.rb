module Api
  module V1
    module Student
      class ExamSerializer < ActiveModel::Serializer
        attributes :id, :name, :start_date, :comment, :status, :section, :klass

        has_many :exam_timetables, if: :include_exam_timetables?

        def include_exam_timetables?
          instance_options[:exam_timetables]
        end

        def section
          object.section.name
        end

        def klass
          object.klass.name
        end
      end
    end
  end
end
