class AddNetIdtoUser < ActiveRecord::Migration
  def change
    add_column :users, :netid, :string
  end
end
