class AttendanceSerializer < ActiveModel::Serializer
  attributes :id, :status, :date, :attendee_type , :attendee_id

  def date
    object.attendance_sheet.name
  end
end
