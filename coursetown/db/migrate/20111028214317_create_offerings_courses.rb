class CreateOfferingsCourses < ActiveRecord::Migration
  def change
    create_table :offerings_courses do |t|
      t.integer :course_id
      t.integer :offering_id

      t.timestamps
    end
  end
end
