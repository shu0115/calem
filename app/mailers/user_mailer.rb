class UserMailer < ApplicationMailer
  def send_access_token(user)
    @user   = user

    mail(
      to:      @user.email,
      subject: "【#{Settings.app_name}】Login URL",
    )
  end
end
