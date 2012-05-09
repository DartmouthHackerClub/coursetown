namespace :import do
  require (Rails.root + "lib/tasks/importer/courseguide_importer.rb")

  desc "Import old reviews, course, and prof data."
  task :courseguide => :environment do |_, args|
    # by default guesses that courseguide db is called 'courseguide'
    args.with_defaults(oldDatabase: 'courseguide')

    # get rails' db name from config files
    new_db = Rails.configuration.database_configuration[Rails.env]["database"]
    old_db = args.oldDatabase

    CourseguideImporter.new(new_db, old_db).execute
  end
end