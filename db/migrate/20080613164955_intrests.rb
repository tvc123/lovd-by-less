class Intrests < ActiveRecord::Migration
  def self.up
    create_table "intrests", :force => true do |t|
      t.string  "name"
    end
     execute "INSERT INTO intrests (name) VALUES ('Membership Recruitment');"
     execute "INSERT INTO intrests (name) VALUES ('Translation');"
     execute "INSERT INTO intrests (name) VALUES ('Grant Research/Writing');"
     execute "INSERT INTO intrests (name) VALUES ('Outreach');"
     execute "INSERT INTO intrests (name) VALUES ('Fundraising');"
     execute "INSERT INTO intrests (name) VALUES ('Marketing');"
     execute "INSERT INTO intrests (name) VALUES ('Digital Media');"
     execute "INSERT INTO intrests (name) VALUES ('Database/Programming');"
     execute "INSERT INTO intrests (name) VALUES ('Curriculum Development');"
     execute "INSERT INTO intrests (name) VALUES ('Mentor Teaching');"
     execute "INSERT INTO intrests (name) VALUES ('In-Country Volunteering');"
     execute "INSERT INTO intrests (name) VALUES ('Evaluation Measurements');"
     execute "INSERT INTO intrests (name) VALUES ('College Internships');"
     execute "INSERT INTO intrests (name) VALUES ('Subject Matter Expertise');"
     execute "INSERT INTO intrests (name) VALUES ('Researchers');"
     execute "INSERT INTO intrests (name) VALUES ('Content Creators');"
     execute "INSERT INTO intrests (name) VALUES ('None');"
     
     
     
     
     
     
  end

  def self.down
    drop_table "intrests"
  end
end
