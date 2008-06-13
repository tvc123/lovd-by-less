class LanguagesUsers < ActiveRecord::Migration
  def self.up
    create_table :languages_users do |t|
            t.integer :user_id
            t.integer :language_id
            t.timestamps
        end
  end

  def self.down
    drop_table :languages_users
  end
end
