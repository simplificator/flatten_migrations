namespace :db do
  desc "Delete all migrations from db/migrate directory and create initial migration from schema"
  task :flatten_migrations do
    migrate_db
    check_schema
    delete_migrations
    create_initial
    create_auxiliary
    migrate_db true
  end
  
  private
    def check_schema
      schema_path = File.join "db", "schema.rb"
      begin
        File.open( File.join( Rails.root.to_s, schema_path ), 'r')
      rescue
        puts "\033[0;91mIt seems that database schema file #{schema_path} is not present.\033[0m"
        puts "Check if you have set schema format to :ruby in your configuration file."
        puts "If yes try to run \033[0;93mrake db:schema:dump.\033[0m"
        exit
      end
    end
    
    def migrate_db( force = false )
      puts "\033[0;95mRunning #{force ? "initial" : "pending "}migration#{force ? "" : "s"}.\033[0m"
      if force then Rake::Task[ "db:migrate" ].reenable end
      Rake::Task[ "db:migrate" ].invoke
      puts "\033[0;92mDone.\033[0m"
    end
    
    def delete_migrations
      puts "\033[0;95mDeleting existing migrations.\033[0m"
      Dir[ File.join Rails.root.to_s, "db", "migrate", "*" ].each{ |f| File.delete f }
      puts "\033[0;92mDone.\033[0m"
    end
    
    def create_initial
      puts "\033[0;95mCreating initial migration from schema.\033[0m"
      
      initial_file  = File.open( File.join( Rails.root.to_s, "db", "migrate", "#{ActiveRecord::Migrator.current_version.to_s}_initial.rb" ), 'w' )
      initial_file.write( 
        "class Initial < ActiveRecord::Migration\n" + \
          "\tdef self.up\n" )
            
      no_write_flag = true
      File.open( File.join( Rails.root.to_s, "db", "schema.rb" ), 'r').each_line do |line|
        initial_file.write "\t#{line.gsub( /,(\s*):force(\s*)=>(\s*)true/, "" )}" unless no_write_flag
        no_write_flag = !( line.starts_with? "ActiveRecord::Schema.define" ) unless !no_write_flag
      end
      
      initial_file.write(
        "\n" + \
          "\tdef self.down\n" + \
            "\t\traise ActiveRecord::IrreversibleMigration\n" + \
          "\tend\n" + \
        "end\n" )
      initial_file.close
      puts "\033[0;92mDone.\033[0m"
    end
    
    def create_auxiliary
      puts "\033[0;95mCreating auxiliary migration that will fix schema_migrations table.\033[0m"
      File.open( File.join( Rails.root.to_s, "db", "migrate", "#{Time.now.strftime "%Y%m%d%H%M%S"}_auxiliary.rb" ), 'w' ) do |f|
        f.puts "class Auxiliary < ActiveRecord::Migration"
        f.puts   "\tdef self.up\n"
        f.puts     "\t\texecute \"TRUNCATE schema_migrations;\""
        f.puts     "\t\texecute \"INSERT INTO schema_migrations VALUES ('#{ActiveRecord::Migrator.current_version.to_s}');\""
        f.puts   "\tend\n"
        f.puts   "\tdef self.down\n"
        f.puts     "\t\traise ActiveRecord::IrreversibleMigration"
        f.puts   "\tend"
        f.puts "end\n"
      end      
    end
end
