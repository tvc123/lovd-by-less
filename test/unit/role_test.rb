require File.dirname(__FILE__) + '/../test_helper'

context "Create new role" do
    it "should create a new role" do
        assert_difference 'Role.count' do
            new_role = Role.create(:rolename => "new role")
            new_role.save
        end
    end
end