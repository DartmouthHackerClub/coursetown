class AddNroableToOffering < ActiveRecord::Migration
  def change
    add_column :offerings, :nroable, :boolean, :default => true
  end
end
