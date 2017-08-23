class AttendanceSerializer < ActiveModel::Serializer
  attributes :id, :status, :date

  def date
    object.attendance_sheet.name
  end
end
