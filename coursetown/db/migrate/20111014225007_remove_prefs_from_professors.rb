class RemovePrefsFromProfessors < ActiveRecord::Migration
  def up
    remove_column :professors, :prefs
    remove_column :professors, :cname
  end

  def down
    add_column :professors, :cname, :string
    add_column :professors, :prefs, :string
  end
end
