require_dependency "project_misc_definitionx/application_controller"

module ProjectMiscDefinitionx
  class MiscDefinitionsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('Misc Definitions')
      @misc_definitions = params[:project_misc_definitionx_misc_definitions][:model_ar_r]
      @misc_definitions = @misc_definitions.where(definition_category: @definition_category) if @definition_category
      @misc_definitions = @misc_definitions.where(project_id: @project.id) if @project
      @misc_definitions = @misc_definitions.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('misc_definition_index_view', 'project_misc_definitionx')
    end
  
    def new
      @title = t('New Misc Definition')
      @misc_definition = ProjectMiscDefinitionx::MiscDefinition.new()
      @erb_code = find_config_const('misc_definition_new_view', 'project_misc_definitionx')
    end
  
    def create
      @misc_definition = ProjectMiscDefinitionx::MiscDefinition.new(params[:misc_definition], :as => :role_new)
      @misc_definition.last_updated_by_id = session[:user_id]
      if @misc_definition.save
        #redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
        redirect_to misc_definitions_path(:project_id => @misc_definition.project_id, :definition_category => @misc_definition.definition_category, :subaction => session[:subaction] ), 
                                                               :notice => t("Successfully Saved!") 
      else
        @project = ProjectMiscDefinitionx.project_class.find_by_id(params[:misc_definition][:project_id]) if params[:misc_definition][:project_id].present?
        @erb_code = find_config_const('misc_definition_new_view', 'project_misc_definitionx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Misc Definition')
      @misc_definition = ProjectMiscDefinitionx::MiscDefinition.find_by_id(params[:id])
      @erb_code = find_config_const('misc_definition_edit_view', 'project_misc_definitionx')
    end
  
    def update
      @misc_definition = ProjectMiscDefinitionx::MiscDefinition.find_by_id(params[:id])
      @misc_definition.last_updated_by_id = session[:user_id]
      if @misc_definition.update_attributes(params[:misc_definition], :as => :role_update)
        #redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        redirect_to misc_definitions_path(:project_id => @misc_definition.project_id, :definition_category => @misc_definition.definition_category, :subaction => session[:subaction] ), 
                                                               :notice => t("Successfully Updated!") 
      else
        @erb_code = find_config_const('misc_definition_edit_view', 'project_misc_definitionx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
    
    def show
      @title = t('Misc Definition Info')
      @misc_definition = ProjectMiscDefinitionx::MiscDefinition.find_by_id(params[:id])
      @erb_code = find_config_const('misc_definition_show_view', 'project_misc_definitionx')
    end
  
    def destroy
      ProjectMiscDefinitionx::MiscDefinition.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    protected
    def load_record
      @definition_category = params[:definition_category].strip if params[:definition_category].present?
      @project = ProjectMiscDefinitionx.project_class.find_by_id(params[:project_id]) if params[:project_id].present?
      @project = ProjectMiscDefinitionx.project_class.find_by_id(ProjectMiscDefinitionx::MiscDefinition.find_by_id(params[:id]).project_id) if params[:id].present?
    end
    
  
    
  end
end
