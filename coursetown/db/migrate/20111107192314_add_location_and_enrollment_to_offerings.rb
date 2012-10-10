class AddLocationAndEnrollmentToOfferings < ActiveRecord::Migration
  def change
		add_column :offerings, :building, :string
		add_column :offerings, :room, :string
		add_column :offerings, :enrollment_cap, :int
		add_column :offerings, :enrolled, :int
  end
end
