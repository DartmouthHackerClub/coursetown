class CreateOldReviews < ActiveRecord::Migration
  def up
    create_table :old_reviews do |t|
      t.integer :id
      t.integer :course
      t.integer :coverall,    :limit => 2
      t.integer :cpace,       :limit => 2
      t.integer :cwork,       :limit => 2
      t.integer :cinterest,   :limit => 2
      t.integer :hlearn,      :limit => 2
      t.integer :hhard,       :limit => 2
      t.integer :hinterest,   :limit => 2
      t.integer :efair,       :limit => 2
      t.integer :ehard,       :limit => 2
      t.integer :loverall,    :limit => 2
      t.integer :lhard,       :limit => 2
      t.integer :ledvalue,    :limit => 2
      t.integer :ctas,        :limit => 2
      t.string :rmajor,       :limit => 2
      t.string :rneed,        :limit => 2
      t.integer :reffort,     :limit => 2
      t.string :roffice,      :limit => 2
      t.integer :rattend,     :limit => 2
      t.string :title
      t.text :creview 
      t.text :lreview
      t.text :fsreview
      t.string :approved
      t.string :modified
      t.text :note
      t.integer :reviewer
      t.integer :rterm,       :limit => 2
      t.datetime :date
      t.timestamp :modifiedat,      :null => false
      t.string :rnotify
      t.integer :ltas,        :limit => 2
      t.integer :interpretas, :limit => 2
      t.string :rhappygrade
      t.integer :cmatchorc,   :limit => 2
      t.string :ip,           :limit => 18
      t.string :hostname,     :limit => 200
      t.integer :ryear
      t.timestamp :lastviewedforedit, :null => false
      t.integer :cdiversity,  :limit => 2
    end
  end

  def down
    drop_table :old_reviews
  end
end

## original schema
#id                | int(10) unsigned
#course            | int(10) unsigned
#coverall          | smallint(5) unsigned
#cpace             | smallint(5) unsigned
#cwork             | smallint(5) unsigned
#cinterest         | smallint(5) unsigned
#hlearn            | smallint(5) unsigned
#hhard             | smallint(5) unsigned
#hinterest         | smallint(5) unsigned
#efair             | smallint(5) unsigned
#ehard             | smallint(5) unsigned
#loverall          | smallint(5) unsigned
#lhard             | smallint(5) unsigned
#ledvalue          | smallint(5) unsigned
#ctas              | smallint(5) unsigned
#rmajor            | enum('Undecided','Major','Minor','Non-Major')
#rneed             | enum('No','Yes')
#reffort           | smallint(5) unsigned
#roffice           | enum('No','Yes')
#rattend           | smallint(5) unsigned
#title             | varchar(255)
#creview           | mediumtext
#lreview           | mediumtext
#fsreview          | mediumtext
#approved          | enum('No','Yes')
#modified          | enum('No','Yes')
#note              | varchar(255)
#reviewer          | int(10) unsigned
#rterm             | smallint(5) unsigned
#date              | datetime
#modifiedat        | timestamp
#rnotify           | enum('No','Yes')
#ltas              | smallint(5) unsigned
#interpretas       | smallint(5) unsigned
#rhappygrade       | enum('No','Yes')
#cmatchorc         | smallint(5) unsigned
#ip                | varchar(18)
#hostname          | varchar(200)
#ryear             | year(4)
#lastviewedforedit | timestamp
#cdiversity        | smallint(5) unsigned
