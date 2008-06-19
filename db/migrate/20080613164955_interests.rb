class Interests < ActiveRecord::Migration
    def self.up
        create_table "interests", :force => true do |t|
            t.string  "name"
        end
        execute "INSERT INTO interests (name) VALUES ('Membership Recruitment');"
        execute "INSERT INTO interests (name) VALUES ('Translation');"
        execute "INSERT INTO interests (name) VALUES ('Grant Research/Writing');"
        execute "INSERT INTO interests (name) VALUES ('Outreach');"
        execute "INSERT INTO interests (name) VALUES ('Fundraising');"
        execute "INSERT INTO interests (name) VALUES ('Marketing');"
        execute "INSERT INTO interests (name) VALUES ('Digital Media');"
        execute "INSERT INTO interests (name) VALUES ('Database/Programming');"
        execute "INSERT INTO interests (name) VALUES ('Curriculum Development');"
        execute "INSERT INTO interests (name) VALUES ('Mentor Teaching');"
        execute "INSERT INTO interests (name) VALUES ('In-Country Volunteering');"
        execute "INSERT INTO interests (name) VALUES ('Evaluation Measurements');"
        execute "INSERT INTO interests (name) VALUES ('College Internships');"
        execute "INSERT INTO interests (name) VALUES ('Subject Matter Expertise');"
        execute "INSERT INTO interests (name) VALUES ('Researchers');"
        execute "INSERT INTO interests (name) VALUES ('Content Creators');"
        execute "INSERT INTO interests (name) VALUES ('None');"

    end

    def self.down
        drop_table "interests"
    end
end
