class CreateOfferings < ActiveRecord::Migration
  def self.up
    create_table :offerings do |t|
      t.integer :course_id
      t.integer :year
      t.string :season, :limit => 1
      t.string :professor
      t.time :time

      t.timestamps
    end
  end

  def self.down
    drop_table :offerings
  end
end
