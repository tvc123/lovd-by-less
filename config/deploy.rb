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
	run "rm #{release_path}/config/initializers/account_config.rb"
        run "ln -nfs #{deploy_to}/shared/system/account_config.rb #{release_path}/config/initializers/account_config.rb"
        
end

task :after_update_code do
        create_sym
end
