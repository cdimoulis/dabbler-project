class UserMailer < ApplicationMailer

  def create_user(user)
    @user = user
    mail(
      to: @user.email,
      subject: I18n.t(:subject, scope: :create_user)
    )
  end

  def change_password(user)
    @user = user
    mail(
      to: @user.email,
      subject: I18n.t(:subject, scope: :change_password)
    )
  end
end
