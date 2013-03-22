require 'spec_helper'

describe "ValueSetMembers" do
  describe "GET /value_set_members" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get value_set_members_path
      response.status.should be(200)
    end
  end
end
