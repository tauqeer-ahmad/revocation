class AdministratorMailer < ApplicationMailer
  def send_password(administrator, institution, password)
    @administrator = administrator
    @institution = institution
    @password = password
    mail(to: @administrator.email, subject: "Revocation administrator password for #{@institution.name}")
  end
end
