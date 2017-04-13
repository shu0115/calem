class SessionsController < ApplicationController
  def callback
    auth = request.env["omniauth.auth"]
    user = User.where(provider: auth["provider"], uid: auth["uid"]).first || User.create_with_omniauth(auth)
    user.auth_update(auth)
    session[:user_id] = user.id

    redirect_to schedules_path
  end

  def destroy
    session[:user_id] = nil

    redirect_to :root
  end

  def failure
    render text: "<span style='color: red;'>Auth Failure</span>"
  end
end
