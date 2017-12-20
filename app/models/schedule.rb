class Schedule < ActiveRecord::Base
  scope :mine, ->(user) { where( schedules: { user_id: user.id } ) }

  validates :title, presence: true
end
