class TeacherMailer < ApplicationMailer
  def send_password(teacher, institution, password)
    @teacher = teacher
    @institution = institution
    @password = password
    mail(to: @teacher.email, subject: "Revocation teacher password for #{@institution.name}")
  end
end
