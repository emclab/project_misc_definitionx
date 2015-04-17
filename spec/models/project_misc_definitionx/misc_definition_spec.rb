require 'rails_helper'

module ProjectMiscDefinitionx
  RSpec.describe MiscDefinition, type: :model do
    it "should be OK" do
      c = FactoryGirl.create(:project_misc_definitionx_misc_definition)
      expect(c).to be_valid
    end
    
    it "should reject 0 project_id" do
      c = FactoryGirl.build(:project_misc_definitionx_misc_definition, :project_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 ranking_index" do
      c = FactoryGirl.build(:project_misc_definitionx_misc_definition, :ranking_index => 0)
      expect(c).not_to be_valid
    end
    
    it "should take nil ranking_index" do
      c = FactoryGirl.build(:project_misc_definitionx_misc_definition, :ranking_index => nil)
      expect(c).to be_valid
    end
    
    it "should reject nil definition category" do
      c = FactoryGirl.build(:project_misc_definitionx_misc_definition, :definition_category => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:project_misc_definitionx_misc_definition, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should have unique batch#" do
      c = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => 1)
      c1 = FactoryGirl.build(:project_misc_definitionx_misc_definition, :project_id => 1)
      expect(c1).not_to be_valid
    end
  end
end
