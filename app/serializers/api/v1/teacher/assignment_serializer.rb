module Api
  module V1
    module Teacher
      class AssignmentSerializer < ActiveModel::Serializer
        attributes :id, :assigned_at, :submission_deadline, :heading, :teacher, :klass, :section, :subject

        attribute :task, if: :include_task?

        def include_task?
          scope&.dig(:include_task)
        end

        def teacher
          object.teacher.name
        end

        def section
          object.section.name
        end

        def subject
          object.subject.name
        end

        def klass
          object.section.klass.name
        end
      end
    end
  end
end
