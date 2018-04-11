module Api
  module V1
    module Guardian
      class StudentAttendanceSerializer < ActiveModel::Serializer
        attributes :id, :day, :status, :late
      end
    end
  end
end
