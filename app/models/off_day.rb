class OffDay < ApplicationRecord
  scope :mine, ->(user) { where( off_days: { user_id: user.id } ) }
end
