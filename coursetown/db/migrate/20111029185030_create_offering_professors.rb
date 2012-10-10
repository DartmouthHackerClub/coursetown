class CreateOfferingProfessors < ActiveRecord::Migration
  def change
    create_table :offering_professors do |t|
      t.integer :professor_id
      t.integer :offering_id

      t.timestamps
    end
  end
end
