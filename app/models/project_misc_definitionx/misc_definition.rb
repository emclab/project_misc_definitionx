module ProjectMiscDefinitionx
  class MiscDefinition < ActiveRecord::Base
    attr_accessor :project_name
    attr_accessible :definition_category, :desp, :name, :project_id, :ranking_index, :definition_category, :project_name,
                    :as => :role_new
    attr_accessible :definition_category, :desp, :name, :ranking_index, :definition_category, :project_name,
                    :as => :role_update
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :project, :class_name => ProjectMiscDefinitionx.project_class.to_s
    
    validates :project_id, :ranking_index, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :name, :presence => true,
                     :uniqueness => {:scope => :project_id, :case_sensitive => false, :message => I18n.t('Duplicate Name!')} 
    validates :definition_category, :presence => true             
  end
end
