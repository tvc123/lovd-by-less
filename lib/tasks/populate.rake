desc "Add default values to the database"
task :pop do

    #Add default admin user
    #Be sure change the password later or in this migration file
    puts 'Adding default admin user'
    user = User.new
    user.login = "admin"
    user.email = GlobalConfig.admin_email
    user.password = "admin"
    user.password_confirmation = "admin"
    user.terms_of_service = true
    user.save(false)
    
    role = Role.find_by_rolename('administrator')
    
    user = User.find_by_login('admin')
    
    permission = Permission.new
    permission.role = role
    permission.user = user
    permission.save(false)

end
