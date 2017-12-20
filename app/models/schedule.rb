class Schedule < ApplicationRecord
  scope :mine, ->(user) { where( schedules: { user_id: user.id } ) }

  validates :title, presence: true
end
