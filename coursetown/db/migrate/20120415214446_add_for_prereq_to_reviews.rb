class AddForPrereqToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :for_prereq, :boolean
  end
end
