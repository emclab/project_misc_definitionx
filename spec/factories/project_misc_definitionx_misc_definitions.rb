# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_misc_definitionx_misc_definition, :class => 'ProjectMiscDefinitionx::MiscDefinition' do
    resource_id 1
    resource_string 'res_str'
    name "MyString"
    desp "MyText"
    ranking_index 1
    definition_category "MyString"
    #last_updated_by_id 1
    fort_token '123456789'
  end
end
