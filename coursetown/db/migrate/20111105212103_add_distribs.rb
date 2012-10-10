class AddDistribs < ActiveRecord::Migration
  def change
    create_table :distribs do |t|
      t.integer :offering_id
      t.string :distrib_name
      t.string :distrib_abbr
    end
  end
end
