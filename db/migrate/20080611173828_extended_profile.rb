class ExtendedProfile < ActiveRecord::Migration
  def self.up
    add_column :users, :city, :string
    add_column :users, :state, :integer
    add_column :users, :zip, :string
    add_column :users, :country, :integer
    add_column :users, :phone, :string
    add_column :users, :phone2, :string
    add_column :users, :msn, :string
    add_column :users, :skype, :string
    add_column :users, :yahoo, :string
    
  end

  def self.down
    remove_column :users, :city, :string
    remove_column :users, :state, :integer
    remove_column :users, :zip, :string
    remove_column :users, :country, :integer
    remove_column :users, :phone, :string
    remove_column :users, :phone2, :string
    remove_column :users, :msn, :string
    remove_column :users, :skype, :string
    remove_column :users, :yahoo, :string
  end
end
