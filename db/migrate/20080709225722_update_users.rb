class UpdateUsers < ActiveRecord::Migration
    def self.up
        rename_column :users, :state, :state_id
        rename_column :users, :country, :country_id
        rename_column :users, :first_language, :language_id
    end

    def self.down
        rename_column :users, :state_id, :state
        rename_column :users, :country_id, :country
        rename_column :users, :language_id, :first_language
    end
end
