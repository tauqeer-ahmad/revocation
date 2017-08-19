class TimetableSerializer < ActiveModel::Serializer
  attributes :get_day_name, :get_start_time, :get_end_time, :teacher_name, :subject_name, :klass_name, :section_name
end
