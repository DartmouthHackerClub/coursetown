class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :department
      t.integer :number
      t.string :short_title
      t.string :long_title
      t.text :desc

      t.timestamps
    end
  end
end
