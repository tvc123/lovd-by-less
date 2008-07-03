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
    system "rake annotate_models"

end

