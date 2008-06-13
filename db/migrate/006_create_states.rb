class CreateStates < ActiveRecord::Migration
    def self.up
        create_table "states", :force => true do |t|
            t.string  "name",         :limit => 128, :default => "", :null => false
            t.string  "abbreviation", :limit => 3,   :default => "", :null => false
            t.integer "country_id",   :limit => 16,  :null => false
        end

        add_index "states", ["country_id"], :name => "country_id"
        
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('ALASKA','AK',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('ALABAMA','AL',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('ARKANSAS','AR',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('AMERICAN SAMOA','AS',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('ARIZONA','AZ',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('CALIFORNIA','CA',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('COLORADO','CO',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('CONNECTICUT','CT',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('DISTRICT OF COLUMBIA','DC',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('WASHINGTON, DC','DC',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('DELAWARE','DE',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('FLORIDA','FL',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('FEDERATED STATES OF MICRONESIA','FM',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('GEORGIA','GA',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('GUAM','GU',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('HAWAII','HI',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('IOWA','IA',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('IDAHO','ID',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('ILLINOIS','IL',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('INDIANA','IN',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('KANSAS','KS',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('KENTUCKY','KY',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('LOUISIANA','LA',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('MASSACHUSETTS','MA',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('MARYLAND','MD',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('MAINE','ME',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('MARSHALL ISLANDS','MH',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('MICHIGAN','MI',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('MINNESOTA','MN',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('MISSOURI','MO',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('NORTHERN MARIANA ISLANDS','MP',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('MISSISSIPPI','MS',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('MONTANA','MT',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('NORTH CAROLINA','NC',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('NORTH DAKOTA','ND',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('NEBRASKA','NE',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('NEW HAMPSHIRE','NH',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('NEW JERSEY','NJ',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('NEW MEXICO','NM',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('NEVADA','NV',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('NEW YORK','NY',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('OHIO','OH',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('OKLAHOMA','OK',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('OREGON','OR',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('PENNSYLVANIA','PA',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('PUERTO RICO','PR',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('PALAU','PW',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('RHODE ISLAND','RI',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('SOUTH CAROLINA','SC',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('SOUTH DAKOTA','SD',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('TENNESSEE','TN',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('TEXAS','TX',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('UTAH','UT',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('VIRGINIA','VA',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('VIRGIN ISLANDS','VI',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('VERMONT','VT',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('WASHINGTON','WA',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('WISCONSIN','WI',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('WEST VIRGINIA','WV',225);"
       execute "INSERT INTO states (name,abbreviation,country_id) VALUES ('WYOMING','WY',225);"
    end

    def self.down
        drop_table :states
    end
end
