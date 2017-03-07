require_dependency "project_misc_definitionx/application_controller"

module ProjectMiscDefinitionx
  class MiscDefinitionsController < ApplicationController
    before_action :require_employee
    before_action :load_record
    protect_from_forgery except: :edit  #for ajax new_log
    after_action :info_logger, :except => [:new, :edit, :event_action_result, :wf_edit_result, :search_results, :stats_results, :acct_summary_result]
    
    def index
      @title = t('Misc Definitions')
      @misc_definitions = params[:project_misc_definitionx_misc_definitions][:model_ar_r]
      @misc_definitions = @misc_definitions.where(definition_category: @definition_category) if @definition_category
      @misc_definitions = @misc_definitions.where('project_misc_definitionx_misc_definitions.resource_id = ?', params[:resource_id]) if params[:resource_id].present? 
      @misc_definitions = @misc_definitions.where('TRIM(project_misc_definitionx_misc_definitions.resource_string) = ?', params[:resource_string].strip) if params[:resource_string].present?
      @erb_code = find_config_const('misc_definition_index_view_' + @definition_category, session[:fort_token], 'project_misc_definitionx')
      @erb_code = find_config_const('misc_definition_index_view', session[:fort_token], 'project_misc_definitionx') if @erb_code.blank?
      
      
      #for csv download
      respond_to do |format|
        format.html {@misc_definitions = @misc_definitions.page(params[:page]).per_page(@max_pagination) }
        format.csv do
          send_data @misc_definitions.role_to_csv('role_definition', params[:index_from].to_i, params[:token?]) if @definition_category == 'role_definition'
          send_data @misc_definitions.position_to_csv('position_definition', params[:index_from].to_i, params[:token?]) if @definition_category == 'position_definition'
        end
      end
    end
  
    def new
      @title = t('New Misc Definition')
      @misc_definition = ProjectMiscDefinitionx::MiscDefinition.new()
      @erb_code = find_config_const('misc_definition_new_view_' + @definition_category, session[:fort_token], 'project_misc_definitionx')
      @erb_code = find_config_const('misc_definition_new_view', session[:fort_token], 'project_misc_definitionx') if @erb_code.blank?
    end
  
    def create
      @misc_definition = ProjectMiscDefinitionx::MiscDefinition.new(new_params)
      @misc_definition.last_updated_by_id = session[:user_id]
      @misc_definition.fort_token = session[:fort_token]
      @misc_definition.resource_id = session[:resource_id] if session[:resource_id].present?
      @misc_definition.resource_string = session[:resource_string] if session[:resource_string].present?
      if @misc_definition.save
        #redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
        redirect_to misc_definitions_path(:resource_id => @misc_definition.resource_id, :resource_string => @misc_definition.resource_string, :definition_category => @misc_definition.definition_category, :subaction => session[:subaction] ), 
                                                               :notice => t("Successfully Saved!") 
      else
        @erb_code = find_config_const('misc_definition_new_view_' + @definition_category, session[:fort_token], 'project_misc_definitionx')
        @erb_code = find_config_const('misc_definition_new_view', session[:fort_token], 'project_misc_definitionx') if  @erb_code.blank?
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Misc Definition')
      @misc_definition = ProjectMiscDefinitionx::MiscDefinition.find_by_id(params[:id])
      @erb_code = find_config_const('misc_definition_edit_view_' + @definition_category, session[:fort_token], 'project_misc_definitionx')
      @erb_code = find_config_const('misc_definition_edit_view', session[:fort_token], 'project_misc_definitionx') if @erb_code.blank?
    end
  
    def update
      @misc_definition = ProjectMiscDefinitionx::MiscDefinition.find_by_id(params[:id])
      @misc_definition.last_updated_by_id = session[:user_id]
      if @misc_definition.update_attributes(edit_params)
        #redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
        redirect_to misc_definitions_path(:resource_id => @misc_definition.resource_id, :resource_string => @misc_definition.resource_string, :definition_category => @misc_definition.definition_category, :subaction => session[:subaction] ), 
                                                               :notice => t("Successfully Updated!") 
      else
        @erb_code = find_config_const('misc_definition_edit_view_' + @definition_category, session[:fort_token], 'project_misc_definitionx')
        @erb_code = find_config_const('misc_definition_edit_view', session[:fort_token], 'project_misc_definitionx') if @erb_code.blank?
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
    
    def show
      @title = t('Misc Definition Info')
      @misc_definition = ProjectMiscDefinitionx::MiscDefinition.find_by_id(params[:id])
      @erb_code = find_config_const('misc_definition_show_view_' + @definition_category, session[:fort_token], 'project_misc_definitionx') if @definitino_category
      @erb_code = find_config_const('misc_definition_show_view', session[:fort_token], 'project_misc_definitionx') if @erb_code.blank?
    end
  
    def destroy
      md = ProjectMiscDefinitionx::MiscDefinition.find_by_id(params[:id].to_i)
      ProjectMiscDefinitionx::MiscDefinition.delete(params[:id].to_i)
      redirect_to misc_definitions_path(:resource_id => md.resource_id, :resource_string => md.resource_string, :definition_category => md.definition_category, :subaction => md.definition_category ), 
                                                               :notice => t("Successfully Deleted!") 
    end
    
    protected
    def load_record
      @resource_id = params[:resource_id] if params[:resource_id].present?
      @resource_string = params[:resource_string].strip if params[:resource_string].present?
      @definition_category = params[:definition_category].strip if params[:definition_category].present?
      @definition_category = ProjectMiscDefinitionx::MiscDefinition.find_by_id(params[:id].to_i).definition_category.strip if params[:id].present?
    end
    
    private
    
    def new_params
      params.require(:misc_definition).permit(:definition_category, :desp, :name, :resource_id, :resource_string, :ranking_index, :definition_category)
    end
    
    def edit_params
      params.require(:misc_definition).permit(:definition_category, :desp, :name, :ranking_index, :definition_category)
    end
 
  end
end
