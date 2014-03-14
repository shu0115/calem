class Schedule < ActiveRecord::Base
  # バリデーション
  validates :title, presence: true
end
