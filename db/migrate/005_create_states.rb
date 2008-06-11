class CreateStates < ActiveRecord::Migration
    def self.up
        create_table "states", :force => true do |t|
            t.string  "name",         :limit => 128, :default => "", :null => false
            t.string  "abbreviation", :limit => 3,   :default => "", :null => false
            t.integer "country_id",   :limit => 16,                  :null => false
        end

        add_index "states", ["country_id"], :name => "country_id"
    end

    def self.down
        drop_table :states
    end
end
