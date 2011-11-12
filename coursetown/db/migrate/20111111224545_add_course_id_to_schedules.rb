class AddCourseIdToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :course_id, :integer
  end
end
