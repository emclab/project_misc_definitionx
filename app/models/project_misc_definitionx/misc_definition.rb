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
    def self.to_csv(project_id, definition_category, start_index=1, token = 'token')
      CSV.generate do |csv|
        #header = ['id', 'name', 'brief_note', 'last_updated_by_id', 'manager_role_id', 'created_at', 'updated_at', 'flag', 'fort_token', 'ranking_index']        
        all.each.with_index(start_index) do |base, i|
          #assembly array for the row
          row = Array.new
          row << i
          row << base.name
          row << base.desp
          row << base.last_updated_by_id
          row << nil #base.manager_role_id. 1 is for head of the company
          row << base.created_at
          row << base.updated_at
          row << '' #base.flag
          row << token 
          row << base.ranking_index
          #inject to csv
          csv << row
       
        end
      end
    end
    
    def self.m_to_csv(definitino_category, proj_ids, releases, tokens) #array
      c_i = 1
      CSV.generate do |csv|
        proj_ids.each do |v|
          i_a = v.split(',')
          prj_id = i_a[1].to_i # '0,25'
          rel = releases[i_a[0].to_i]
          token = tokens[i_a[0].to_i]
          records = MiscDefinition.where('resource_id = ? AND resource_string = ? AND release_id = ? AND definition_category = ?',  prj_id, ProjectMiscDefinitionx.project_class_string, rel, definition_category )
          
          records.each do |config|
            #assembly array for the row
            csv << make_row(config, c_i, token)
            c_i += 1
          end
        end
      end
    end
    
    def self.make_row(base, i, token)
      row = Array.new
      row << i
      row << base.name
      row << base.desp
      row << base.last_updated_by_id
      row << nil #base.manager_role_id. 1 is for head of the company
      row << base.created_at
      row << base.updated_at
      row << '' #base.flag
      row << token 
      row << base.ranking_index
      #inject to csv
      csv << row
      
      return row
    end

=begin    
    def self.position_to_csv(project_id, definition_category = 'position_definition', start_index=1, token = 'token')
      CSV.generate do |csv|
        #header = ['id', 'user_group_name', 'short_note', 'zone_id', 'group_type_id', manager+_group_id, 'created_at', 'updated_at', token]        
        all.each.with_index(start_index) do |base, i|
          #assembly array for the row
          row = Array.new
          row << i
          row << base.name
          row << base.desp
          row << 1 #hq, zone_id. 
          row << 1 #employee, group_type_id
          row << nil #general manager, manager group id
          row << base.created_at
          row << base.updated_at
          row << token 
          #inject to csv
          csv << row
       
        end
      end
    end  
=end
              
  end
end
