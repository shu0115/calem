class Schedule < ActiveRecord::Base
  # スコープ
  scope :mine, ->(user) { where( schedules: { user_id: user.id } ) }

  # バリデーション
  validates :title, presence: true
end
