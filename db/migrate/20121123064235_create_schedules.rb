class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :user_id
      t.string :title
      t.text :note
      t.timestamp :start_time
      t.timestamp :end_time

      t.timestamps
    end
  end
end
