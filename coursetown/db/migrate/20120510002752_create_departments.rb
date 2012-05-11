class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :abbr
      t.string :name

      t.timestamps
    end
  end
end
