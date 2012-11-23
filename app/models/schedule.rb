class Schedule < ActiveRecord::Base
  attr_accessible :end_time, :note, :set_date, :start_time, :title, :user_id
end
