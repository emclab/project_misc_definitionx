class CreateProjectMiscDefinitionxMiscDefinitions < ActiveRecord::Migration
  def change
    create_table :project_misc_definitionx_misc_definitions do |t|
      t.integer :resource_id
      t.string :resource_string
      t.string :name
      t.text :desp
      t.integer :ranking_index
      t.string :definition_category
      t.integer :last_updated_by_id
      t.timestamps
      t.string :fort_token
      
    end
    
    add_index :project_misc_definitionx_misc_definitions, :resource_id, :name => :res_id
    add_index :project_misc_definitionx_misc_definitions, :resource_string, :name => :res_string
    add_index :project_misc_definitionx_misc_definitions, :name
    add_index :project_misc_definitionx_misc_definitions, :definition_category, :name => :project_misc_definitionx_misc_definitions_category
    add_index :project_misc_definitionx_misc_definitions, :fort_token
  end
end
