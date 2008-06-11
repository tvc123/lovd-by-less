class ExtendedProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :city, :string
    add_column :profiles, :state, :integer
    add_column :profiles, :zip, :string
    add_column :profiles, :country, :integer
    add_column :profiles, :phone, :string
    add_column :profiles, :phone2, :string
    add_column :profiles, :msn, :string
    add_column :profiles, :skype, :string
    add_column :profiles, :yahoo, :string
    
  end

  def self.down
  end
end
