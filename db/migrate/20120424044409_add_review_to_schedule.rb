class AddReviewToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :review_id, :int
    remove_column :reviews, :user_id
  end
end
