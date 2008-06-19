task :mig do
  puts 'rake db:migrate RAILS_ENV="development"'
  system "rake db:migrate RAILS_ENV='development'"
  puts "rake db:test:clone"
  system "rake db:test:clone"
  if !ENV['a'].nil? && ENV['a'].size > 0
    puts "NOT RUNNING: rake annotate_models"
  else
    system "rake annotate_models"
  end
end


task :dodb do

    puts 'resetting databases'
    
    puts 'droping databases'
    system "rake db:drop:all"
    
    puts 'creating databases'
    system "rake db:create:all"
    
    puts 'migrating'
    system "rake db:migrate"
    
    puts 'setting up test db'
    system "rake db:test:prepare"
    
    puts 'annotating models'
    system "annotate"

end

