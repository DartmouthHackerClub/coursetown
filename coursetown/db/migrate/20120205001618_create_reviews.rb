class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer  "user_id"
      t.integer  "offering_id"
      
      t.integer  "grade"
      t.integer  "prof_rating"
      t.integer  "course_rating"
      t.text     "comment"
      
      t.timestamps
    end
  end
end
