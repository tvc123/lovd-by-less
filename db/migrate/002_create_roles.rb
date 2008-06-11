class CreateRoles < ActiveRecord::Migration
    def self.up
        create_table :roles do |t|
            t.string :rolename
            t.timestamps
        end

        Role.create(:rolename => 'administrator')
        Role.create(:rolename => 'user')

    end

    def self.down
        drop_table :roles
    end
end
