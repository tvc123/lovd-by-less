set :application, "ozmozr"
set :repository,  "git://github.com/tvc123/lovd-by-less.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, :git
default_run_options[:pty] = true # or else you'll get "sorry, you must have a tty to run sudo" 

role :app, "twb1.enpraxis.net"
role :web, "twb1.enpraxis.net"
role :db,  "twb1.enpraxis.net", :primary => true

ssh_options[:port] = 2224

set :user, "git"
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :export

desc "create symlinks from rails dir into project"
task :create_sym do
        run "ln -nfs #{deploy_to}/shared/system/database.yml #{release_path}/config/database.yml"
        run "ln -nfs #{deploy_to}/shared/system/mail.rb #{release_path}/config/initializers/mail.rb"
	#    run "rm #{release_path}/config/initializers/account_config.rb"
    #    run "ln -nfs #{deploy_to}/shared/system/account_config.rb #{release_path}/config/initializers/account_config.rb"
        
end

task :after_update_code do
        create_sym
end

task :tail_log, :roles => :app do
stream "tail -f #{shared_path}/log/production.log"
end


set :monit_group, 'git'
desc <<-DESC
Restart the Mongrel processes on the app server by
calling restart_mongrel_cluster.
DESC
task :restart, :roles => :app do
	restart_mongrel_cluster
end
desc <<-DESC
Restart the Mongrel processes on the app server by
calling restart_mongrel_cluster.
DESC
deploy.task :restart, :roles => :app do
	restart_mongrel_cluster
end
desc <<-DESC
Start Mongrel processes on the app server.
DESC
task :start_mongrel_cluster , :roles => :app do
sudo "/usr/local/bin/monit start all -g #{monit_group}"
end
desc <<-DESC
Restart the Mongrel processes on the app server by
starting and stopping the cluster.
DESC
task :restart_mongrel_cluster , :roles => :app do
#sudo "/usr/local/bin/monit restart all -g #{monit_group}"
sudo " /usr/local/bin/mongrel_rails cluster::restart  -C /var/www/ozmozr/current/config/mongrel_cluster.yml"
end
desc <<-DESC
Stop the Mongrel processes on the app server.
DESC
task :stop_mongrel_cluster , :roles => :app do
sudo "/usr/local/bin/monit stop all -g #{monit_group}"
end

