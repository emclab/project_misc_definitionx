require 'spec_helper'

module ProjectMiscDefinitionx
  describe MiscDefinitionsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
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
    end
      
    render_views
    
    describe "GET 'index'" do
      it "returns all misc definitions for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_role_definition', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectMiscDefinitionx::MiscDefinition.scoped.order('ranking_index')")     
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => @proj.id, :definition_category => 'role_definition')
        qs1 = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => qs.project_id, :name => 'new')
        get 'index' , {:use_route => :project_misc_definitionx, :project_id => @proj.id, :subaction => 'role_definition', :definition_category => 'role_definition'}
        assigns(:misc_definitions).should =~ [qs]       
      end
      
      it "should return for a category" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectMiscDefinitionx::MiscDefinition.scoped.order('ranking_index')")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition, :last_updated_by_id => @u.id, :definition_category => 'new category')
        qs1 = FactoryGirl.create(:project_misc_definitionx_misc_definition, :last_updated_by_id => @u.id, :project_id => qs.project_id + 1 )
        get 'index' , {:use_route => :project_misc_definitionx, :definition_category => qs.definition_category}
        assigns(:misc_definitions).should eq([qs])
      end
      
      it "should returns all definition for a project" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectMiscDefinitionx::MiscDefinition.scoped.order('ranking_index')")    
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition, :last_updated_by_id => @u.id, :name => 'new new')
        qs1 = FactoryGirl.create(:project_misc_definitionx_misc_definition, :last_updated_by_id => @u.id, :project_id => qs.project_id)
        get 'index' , {:use_route => :project_misc_definitionx, :project_id => qs1.project_id, :definition_category => qs1.definition_category}
        assigns(:misc_definitions).should =~ [qs1, qs]     
      end
      
    end
  
    describe "GET 'new'" do
      
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , {:use_route => :project_misc_definitionx, :project_id => @proj.id, :definition_category => 'some_cate'}
        response.should be_success
      end
           
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:project_misc_definitionx_misc_definition, :project_id => @proj.id, :definition_category => 'category')
        get 'create' , {:use_route => :project_misc_definitionx,  :misc_definition => qs}
        #response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
        redirect_to misc_definitions_path(:project_id => @proj.id, :definition_category => 'category', :subaction => session[:subaction] ) #, 
                                                               #:notice => I18n.t("Successfully Saved!") 
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:project_misc_definitionx_misc_definition, :name => nil)
        get 'create' , {:use_route => :project_misc_definitionx,  :misc_definition => qs}
        response.should render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition)
        get 'edit' , {:use_route => :project_misc_definitionx,  :id => qs.id}
        response.should be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => @proj.id, :definition_category => 'category')
        get 'update' , {:use_route => :project_misc_definitionx,  :id => qs.id, :misc_definition => {:name => 'newnew'}}
        #response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        redirect_to misc_definitions_path(:project_id => @proj.id, :definition_category => 'category', :subaction => session[:subaction] )
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition)
        get 'update' , {:use_route => :project_misc_definitionx,  :id => qs.id, :misc_definition => {:ranking_index => 0}}
        response.should render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_misc_definitionx_misc_definition, :project_id => @proj.id, :last_updated_by_id => @u.id)
        get 'show' , {:use_route => :project_misc_definitionx,  :id => qs.id, :definition_category => qs.definition_category }
        response.should be_success
      end
    end
  
    describe "GET 'destroy'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource =>'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:project_misc_definitionx_misc_definition)
        get 'destroy', {:use_route => :project_misc_definitionx, :id => q.id }
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
      end
    end
  
  end
end
