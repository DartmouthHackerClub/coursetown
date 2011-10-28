class CreateOfferings < ActiveRecord::Migration
  def change
    create_table :offerings do |t|
      t.integer :year
      t.string :term
      t.string :time
      t.float :median_grade
      t.string :specific_title
      t.string :wc
      t.string :desc
      t.boolean :unconfirmed
      t.string :crn
      t.integer :section

      t.timestamps
    end
  end
end
