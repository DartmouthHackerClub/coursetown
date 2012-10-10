class AddSpecificCommentsToReviews < ActiveRecord::Migration
  def change
    change_table :reviews do |t|
      # specific comments
      t.text :course_comment
      t.text :prof_comment
      t.text :workload_comment

      # add workload_rating
      t.integer :workload_rating

      # remove old one-size-fits-all comment
      t.remove :comment

      # motivations for taking the course
      t.boolean :for_interest
      t.boolean :for_prof
      t.boolean :for_major
      t.boolean :for_distrib
      t.boolean :for_easy_a
    end
  end
end
