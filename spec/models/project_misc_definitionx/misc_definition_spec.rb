require 'spec_helper'

module ProjectMiscDefinitionx
  describe MiscDefinition do
    it "should be OK" do
      c = FactoryGirl.create(:project_misc_definitionx_misc_definition)
      c.should be_valid
    end
    
    it "should reject 0 project_id" do
      c = FactoryGirl.build(:project_misc_definitionx_misc_definition, :project_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 ranking_index" do
      c = FactoryGirl.build(:project_misc_definitionx_misc_definition, :ranking_index => 0)
      c.should_not be_valid
    end
    
    it "should take ranking_index" do
      c = FactoryGirl.build(:project_misc_definitionx_misc_definition, :ranking_index => nil)
      c.should be_valid
    end
    
    it "should reject nil definition category" do
      c = FactoryGirl.build(:project_misc_definitionx_misc_definition, :definition_category => nil)
      c.should_not be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:project_misc_definitionx_misc_definition, :name => nil)
      c.should_not be_valid
    end
    
    it "should have unique name" do
      c = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => 1)
      c1 = FactoryGirl.build(:project_misc_definitionx_misc_definition, :project_id => 1)
      c1.should_not be_valid
    end
    
    it "should be OK with different category" do
      c = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => 1)
      c1 = FactoryGirl.build(:project_misc_definitionx_misc_definition, :project_id => 1, :definition_category => 'a new category')
      c1.should be_valid
    end
  end
end
