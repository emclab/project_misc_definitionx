class CreateProjectMiscDefinitionxMiscDefinitions < ActiveRecord::Migration
  def change
    create_table :project_misc_definitionx_misc_definitions do |t|
      t.integer :project_id
      t.string :name
      t.text :desp
      t.integer :ranking_index
      t.string :definition_category
      t.integer :last_updated_by_id

      t.timestamps
    end
    
    add_index :project_misc_definitionx_misc_definitions, :project_id
    add_index :project_misc_definitionx_misc_definitions, :name
    add_index :project_misc_definitionx_misc_definitions, :definition_category, :name => :project_misc_definitionx_misc_definitions_category
  end
end
