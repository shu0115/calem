class CreateOffDays < ActiveRecord::Migration[4.2]
  def change
    create_table :off_days do |t|
      t.integer :user_id
      t.date :target_day

      t.timestamps
    end
  end
end
