class CreatePloneOpenRoles < ActiveRecord::Migration
    def self.up
        create_table :plone_open_roles do |t|
            t.string :login, :rolename
            t.timestamps
        end
    end

    def self.down
        drop_table :plone_open_roles
    end
end
