class ApplicationMailer < ActionMailer::Base
  default from: "no_reply@dabbler.fyi"
  layout 'mailer'
end
