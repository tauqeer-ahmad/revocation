module Api
  module V1
    module Guardian
      class TimetableSerializer < ActiveModel::Serializer
        attributes :id, :day_name, :start_time, :end_time, :teacher_name, :subject_name, :klass_name, :section_name

        def day_name
          object.get_day_name
        end

        def start_time
          object.get_start_time
        end

        def end_time
          object.get_end_time
        end
      end
    end
  end
end
