class StudentMailer < ApplicationMailer
  def send_password(student, institution, password)
    @student = student
    @institution = institution
    @password = password
    mail(to: @student.email, subject: "Revocation student password for #{@institution.name}")
  end
end
