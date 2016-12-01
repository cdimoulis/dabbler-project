class UserMailer < ApplicationMailer

  def create_user(user)
    @user = user
    mail(
      to: @user.email,
      subject: I18n.t(:subject)
    )
  end
end
