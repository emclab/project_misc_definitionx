module ProjectMiscDefinitionx
  class MiscDefinition < ActiveRecord::Base
    attr_accessor :project_name
=begin
    attr_accessible :definition_category, :desp, :name, :project_id, :ranking_index, :definition_category, :project_name, 
                    :as => :role_new
    attr_accessible :definition_category, :desp, :name, :ranking_index, :definition_category, :project_name,
                    :as => :role_update
=end
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :project, :class_name => ProjectMiscDefinitionx.project_class.to_s
    
    validates :project_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :name, :presence => true,
                     :uniqueness => {:scope => [:project_id, :definition_category], :case_sensitive => false, :message => I18n.t('Duplicate Name!')} 
    validates :ranking_index, :numericality => {:only_integer => true, :greater_than => 0}, :if => 'ranking_index.present?'
    validates :definition_category, :presence => true   
    validate :dynamic_validate
      
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_' + definition_category, 'project_misc_definitionx') if definition_category
      eval(wf) if wf.present?
    end   
    
    #role convert to csv
    def self.role_to_csv(project_id, definition_category = 'role_definition', start_index=1, token = 'token')
      CSV.generate do |csv|
        #header = ['id', 'name', 'brief_note', 'last_updated_by_id', 'manager_role_id', 'created_at', 'updated_at', 'flag', 'fort_token', 'ranking_index']        
        all.each.with_index(start_index) do |config, i|
          #assembly array for the row
          base = ProjectMiscDefinitionx::MiscDefinition.where('project_id = ? AND definition_category = ?', project_id, definition_category)
          row = Array.new
          row << i
          row << base.name
          row << base.brief_note
          row << base.last_updated_by_id
          row << base.manger_role_id
          row << base.created_at
          row << base.updated_at
          row << base.flag
          row << token 
          row << base.ranking_index
          #inject to csv
          csv << row
       
        end
      end
    end                  
  end
end
