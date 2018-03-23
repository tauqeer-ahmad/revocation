module Api
  module V1
    module Teacher
      class TeacherAttendanceSerializer < ActiveModel::Serializer
        attributes :id, :day, :status, :late, :arrival, :departure
      end
    end
  end
end
