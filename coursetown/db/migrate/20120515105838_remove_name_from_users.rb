class RemoveNameFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :name
    # sha1-hash of netid
    add_column :users, :hashed_netid, :string

    User.reset_column_information

    User.all.each do |u|
      u.hashed_netid = User.hash_netid(u.netid)
      u.save
    end

    remove_column :users, :netid

    add_index :users, :hashed_netid
  end

  def down
    remove_column :users, :netid_sha1
    add_column :users, :name, :string
    add_column :users, :netid, :string

    remove_index :users, :hashed_netid
  end
end
