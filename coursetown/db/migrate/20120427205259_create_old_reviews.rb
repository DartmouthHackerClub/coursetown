class CreateOldReviews < ActiveRecord::Migration
  def up
    create_table :old_reviews do |t|
      t.integer :id
      t.integer :course
      t.integer :coverall
      t.integer :cpace
      t.integer :cwork
      t.integer :cinterest
      t.integer :hlearn
      t.integer :hhard
      t.integer :hinterest
      t.integer :efair
      t.integer :ehard
      t.integer :loverall
      t.integer :lhard
      t.integer :ledvalue
      t.integer :ctas
      t.string :rmajor
      t.string :rneed
      t.integer :reffort
      t.string :roffice
      t.integer :rattend
      t.string :title
      t.text :creview
      t.text :lreview
      t.text :fsreview
      t.string :approved
      t.string :modified
      t.text :note
      t.integer :reviewer
      t.integer :rterm
      t.datetime :date
      t.timestamp :modifiedat
      t.string :rnotify
      t.integer :ltas
      t.integer :interpretas
      t.string :rhappygrade
      t.integer :cmatchorc
      t.string :ip
      t.string :hostname
      t.integer :ryear
      t.timestamp :lastviewedforedit
      t.integer :cdiversity
    end

    # get the database of the current environment
    config   = Rails.configuration.database_configuration
    database = config[Rails.env]["database"]

    # dump old reviews
    system('mysqldump --user=courseguide --password=ratepandc courseguide reviews > old_reviews.sql')
    
    # rename `reviews` table to `old_reviews`
    system("sed -i -e 's/`reviews`/`old_reviews`/' old_reviews.sql")
    
    # import the dump
    system("mysql -ucoursetown -pBLP80ZKB8nB8 -D#{database} < old_reviews.sql")
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
