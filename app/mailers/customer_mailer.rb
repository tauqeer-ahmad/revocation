class CustomerMailer < ApplicationMailer
  def contact_us(receiver_email, sender_email, contact_number, subject, message)
    receiver_email ||= 'contact@revocation.pk'

    @information = {
      email: sender_email,
      contact_number: contact_number,
      message: message,
    }

    mail(to: receiver_email, subject: subject)
  end
end
