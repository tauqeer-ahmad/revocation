class GuardianMailer < ApplicationMailer
  def send_password(guardian, institution, password)
    @guardian = guardian
    @institution = institution
    @password = password
    mail(to: @guardian.email, subject: "Revocation parent/guardian password for #{@institution.name}")
  end
end
