class LanguagesUsers < ActiveRecord::Migration
    def self.up
        create_table :languages_users, :id => false, :force => true do |t|
            t.integer :user_id
            t.integer :language_id
            t.timestamps
        end
        
        add_index :languages_users, [:user_id, :language_id]
        add_index :languages_users, :user_id
        
    end

    def self.down
        drop_table :languages_users
    end
end
