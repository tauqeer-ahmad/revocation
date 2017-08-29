class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@revocation.pk'
  layout 'mailer'
end
