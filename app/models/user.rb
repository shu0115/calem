class User < ActiveRecord::Base
  # auth情報更新
  def auth_update(auth)
    image_path = auth["info"]["image"].to_s.gsub('_normal', '') rescue nil
    self.name        = auth["info"]["name"]     if auth["info"]["name"].present?
    self.screen_name = auth["info"]["nickname"] if auth["info"]["nickname"].present?
    self.image       = image_path               if image_path.present?
    self.save!
  rescue => e
    puts "[ ---------- e ---------- ]" ; e.tapp ;
    return nil
  end

  private

  def self.create_with_omniauth( auth )
    user = User.new
    user[:provider] = auth["provider"]
    user[:uid]      = auth["uid"]

    unless auth["info"].blank?
      user[:name]     = auth["info"]["name"]
      user[:nickname] = auth["info"]["nickname"]
      user[:image]    = auth["info"]["image"]
    end

    unless auth["credentials"].blank?
      user.token  = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end

    user.save

    return user
  end
end
