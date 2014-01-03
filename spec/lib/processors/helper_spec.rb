require 'spec_helper'
require './lib/processors/helper'

describe Processor::Helper do
  before(:each) do
    @patient = Patient.first
  end
    
  describe "find_all_items" do
    it "returns nil if there are no codes" do
      Processor::Helper.find_all_items(@patient, []).should be_nil
      Processor::Helper.find_all_items(@patient, nil).should be_nil
    end
    
    it "returns nil if the patient is nil" do
      Processor::Helper.find_all_items(nil, ["1000"]).should be_nil
    end
  end
end