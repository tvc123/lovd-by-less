class CreateGradeLevelExperiencesUsers < ActiveRecord::Migration
    def self.up
        create_table :grade_level_experiences_users, :id => false, :force => true do |t|
            t.integer :user_id
            t.integer :grade_level_experience_id
            t.timestamps
        end
    end

    def self.down
        drop_table :grade_level_experiences_users
    end
end