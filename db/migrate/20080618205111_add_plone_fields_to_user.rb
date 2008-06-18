class AddPloneFieldsToUser < ActiveRecord::Migration
    def self.up
        add_column :users, :plone_password, :string, :limit => 40
    end

    def self.down
        remove_column :users, :plone_password, :string
    end
end
