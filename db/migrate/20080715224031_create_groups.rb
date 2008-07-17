class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|

        t.column "title", :string
        t.column "name", :string
        t.column "description", :text
        t.column "community_created_at", :datetime
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
        
        t.column "name",         :string,   :limit => 100
        t.column "description",  :text
        
        t.column "meets",        :string,   :limit => 100
        t.column "location",     :string,   :limit => 100
        t.column "directions",   :text
        t.column "other_notes",  :text
        t.column "category",     :string,   :limit => 50
        t.column "creator_id",   :integer
        t.column "private",      :boolean,                 :default => false
        t.column "address",      :string
        t.column "members_send", :boolean,                 :default => true
        t.column "leader_id",    :integer
        t.column "updated_at",   :datetime
        t.column "hidden",       :boolean,                 :default => false
        t.column "approved",     :boolean,                 :default => false
        t.column "link_code",    :string
        t.column "parents_of",   :integer
        t.column "site_id",      :integer
        
        
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
