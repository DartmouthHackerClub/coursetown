class CreateSchedules < ActiveRecord::Migration
  def up
    create_table :schedules do |t|
      t.integer :offering_id
      t.integer :user_id
      t.timestamps
    end
  end

  def down
    drop_table :schedules
  end
end
