class CreatePloneGroupRoles < ActiveRecord::Migration
    def self.up
        create_table :plone_group_roles do |t|
            t.string :login, :rolename
            t.timestamps
        end
    end

    def self.down
        drop_table :plone_group_roles
    end
end
