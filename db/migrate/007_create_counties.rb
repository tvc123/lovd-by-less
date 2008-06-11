class CreateCounties < ActiveRecord::Migration
    def self.up

        create_table "counties", :force => true do |t|
            t.string "name", :limit => 128, :default => "", :null => false
            t.integer "state_id",   :limit => 16, :null => false
        end

        add_index "counties", ["state_id"], :name => "state_id"

    end

    def self.down
        drop_table :counties
    end
    
end
