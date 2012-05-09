class AdaptForOldData < ActiveRecord::Migration
  def change
    add_column :professors, :last_name, :string

    add_column :offerings, :median_from_transcript, :boolean
    add_column :offerings, :enrollment_from_transcript, :boolean
    add_column :offerings, :old_id, :integer

    add_column :old_reviews, :old_id, :integer
    add_column :old_reviews, :old_offering_id, :integer
    remove_column :old_reviews, :course
  end
end
