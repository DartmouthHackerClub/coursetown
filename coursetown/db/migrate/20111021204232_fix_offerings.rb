class FixOfferings < ActiveRecord::Migration
  def up
    rename_column :offerings, :season, :term
    change_table :offerings do |t|
      t.change :time, :string
    end
  end

  def down
    rename_column :offerings, :term, :season
    change_table :offerings do |t|
      t.change :time, :time
    end
  end
end
