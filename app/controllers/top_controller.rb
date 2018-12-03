class TopController < ApplicationController
  def index
  end

  def send_access_token(email: nil)
    redirect_to root_path and return if email.blank?

    access_token_generate_key = SecureRandom.uuid
    access_token              = Digest::SHA256.hexdigest(access_token_generate_key)

    user = User.find_or_create_by!(email: email.strip)
    user.update!(access_token: access_token, access_token_expired_at: Time.current.since(10.minute))

    session[:email]                     = user.email
    session[:access_token_generate_key] = access_token_generate_key

    UserMailer.send_access_token(user).deliver_now

    flash[:notice] = 'Sent email.'

    redirect_to root_path and return
  end

  def verify_access_token(token: nil)
    redirect_to root_path and return if current_user.present?

    access_token = Digest::SHA256.hexdigest(session[:access_token_generate_key])
    user         = User.find_by(email: session[:email])

    if user.blank?
      flash[:alert] = "ユーザが存在しません。"
    elsif token.blank? || user.access_token.blank? || !([token, user.access_token].all?{ |x| x == access_token })
      flash[:alert] = "認証情報が正しくありません。"
    elsif user.access_token_expired_at < Time.now
      flash[:alert] = "有効期限が過ぎています。"
    else
      user.update!(active_flag: true)

      session[:email]                     = nil
      session[:access_token_generate_key] = nil
      session[:user_id]                   = user.id
    end

    redirect_to schedules_path and return
  end
end
