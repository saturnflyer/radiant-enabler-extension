namespace :radiant do
  namespace :extensions do
    namespace :enabler do
      
      desc "Runs the migration of the Enabler extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          EnablerExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          EnablerExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Enabler to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from EnablerExtension"
        Dir[EnablerExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(EnablerExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
        unless EnablerExtension.root.starts_with? RAILS_ROOT # don't need to copy vendored tasks
          puts "Copying rake tasks from EnablerExtension"
          local_tasks_path = File.join(RAILS_ROOT, %w(lib tasks))
          mkdir_p local_tasks_path, :verbose => false
          Dir[File.join EnablerExtension.root, %w(lib tasks *.rake)].each do |file|
            cp file, local_tasks_path, :verbose => false
          end
        end
      end  
    end
  end
end
