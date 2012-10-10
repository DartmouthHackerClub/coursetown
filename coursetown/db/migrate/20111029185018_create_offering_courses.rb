class CreateOfferingCourses < ActiveRecord::Migration
  def change
    create_table :offering_courses do |t|
      t.integer :course_id
      t.integer :offering_id

      t.timestamps
    end
  end
end
