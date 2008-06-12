class CreateGradeLevelExperiences < ActiveRecord::Migration
  def self.up
    create_table :grade_level_experiences do |t|
      t.string "name"
      t.timestamps
    end
    execute "INSERT INTO grade_level_experiences (name) VALUES ('College');"
    execute "INSERT INTO grade_level_experiences (name) VALUES ('High School');"
    execute "INSERT INTO grade_level_experiences (name) VALUES ('Middle School');"
    execute "INSERT INTO grade_level_experiences (name) VALUES ('Grade School');"
    execute "INSERT INTO grade_level_experiences (name) VALUES ('Pre K');"
    execute "INSERT INTO grade_level_experiences (name) VALUES ('None');"
  end

  def self.down
    drop_table :grade_level_experiences
  end
end
