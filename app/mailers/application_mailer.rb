class ApplicationMailer < ActionMailer::Base
  default from: "default@swing-city.herokuapp.com/"
  layout 'mailer'
end
