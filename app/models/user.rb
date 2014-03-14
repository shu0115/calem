class User < ActiveRecord::Base
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
