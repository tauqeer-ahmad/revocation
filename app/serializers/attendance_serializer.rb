class AttendanceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :status, :date

  def date
    object.attendance_sheet.name
  end
end
