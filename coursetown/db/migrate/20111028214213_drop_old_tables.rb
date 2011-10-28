class DropOldTables < ActiveRecord::Migration
  def up
    drop_table :courses
    drop_table :offerings
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
