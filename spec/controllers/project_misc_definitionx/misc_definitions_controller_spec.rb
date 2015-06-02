require 'rails_helper'

module ProjectMiscDefinitionx
  RSpec.describe MiscDefinitionsController, type: :controller do
    routes {ProjectMiscDefinitionx::Engine.routes}
    before(:each) do
      #expect(controller).to receive(:require_signin)
      expect(controller).to receive(:require_employee)
    end
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])

      @proj = FactoryGirl.create(:info_service_projectx_project)
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
      
    render_views
    
    describe "GET 'index'" do
      it "returns all misc definitions for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_role_definition', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectMiscDefinitionx::MiscDefinition.all.order('ranking_index')")     
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => @proj.id, :definition_category => 'role_definition')
        qs1 = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => qs.project_id, :name => 'new')
        get 'index' , {:project_id => @proj.id, :subaction => 'role_definition', :definition_category => 'role_definition'}
        expect(assigns(:misc_definitions)).to match_array([qs])      
      end
      
      it "should return for a category" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectMiscDefinitionx::MiscDefinition.all.order('ranking_index')")        
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition, :last_updated_by_id => @u.id, :definition_category => 'new category')
        qs1 = FactoryGirl.create(:project_misc_definitionx_misc_definition, :last_updated_by_id => @u.id, :project_id => qs.project_id + 1 )
        get 'index' , {:definition_category => qs.definition_category}
        expect(assigns(:misc_definitions)).to match_array([qs])
      end
      
      it "should returns all definition for a project" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectMiscDefinitionx::MiscDefinition.all.order('ranking_index')")    
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition, :last_updated_by_id => @u.id, :name => 'new new')
        qs1 = FactoryGirl.create(:project_misc_definitionx_misc_definition, :last_updated_by_id => @u.id, :project_id => qs.project_id)
        get 'index' , {:project_id => qs1.project_id, :definition_category => qs1.definition_category}
        expect(assigns(:misc_definitions)).to match_array([qs1, qs])     
      end
      
    end
  
    describe "GET 'new'" do
      
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        get 'new' , {:project_id => @proj.id, :definition_category => 'some_cate'}
        expect(response).to be_success
      end
           
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.attributes_for(:project_misc_definitionx_misc_definition, :project_id => @proj.id, :definition_category => 'category')
        get 'create' , { :misc_definition => qs}
        #expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
        redirect_to misc_definitions_path(:project_id => @proj.id, :definition_category => 'category', :subaction => session[:subaction] ) #, 
                                                               #:notice => I18n.t("Successfully Saved!") 
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.attributes_for(:project_misc_definitionx_misc_definition, :name => nil)
        get 'create' , { :misc_definition => qs, :definition_category => 'test'}
        expect(response).to render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition)
        get 'edit' , { :id => qs.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => @proj.id, :definition_category => 'category')
        get 'update' , { :id => qs.id, :misc_definition => {:name => 'newnew'}}
        #expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        redirect_to misc_definitions_path(:project_id => @proj.id, :definition_category => 'category', :subaction => session[:subaction] )
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition)
        get 'update' , { :id => qs.id, :misc_definition => {:ranking_index => 0}}
        expect(response).to render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => @proj.id, :last_updated_by_id => @u.id)
        get 'show' , { :id => qs.id, :definition_category => qs.definition_category }
        expect(response).to be_success
      end
    end
  
    describe "GET 'destroy'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource =>'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:project_misc_definitionx_misc_definition)
        get 'destroy', {:id => q.id }
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
      end
    end
  
  end
end
