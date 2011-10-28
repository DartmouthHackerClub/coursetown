class CreateOfferingsProfessors < ActiveRecord::Migration
  def change
    create_table :offerings_professors do |t|
      t.integer :professor_id
      t.integer :offering_id

      t.timestamps
    end
  end
end
