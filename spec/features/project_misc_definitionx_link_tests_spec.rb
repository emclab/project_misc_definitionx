require 'spec_helper'

describe "LinkTests" do
  describe "GET /project_misc_definitionx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
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
      @definition_category = 'role_definition'
      user_access = FactoryGirl.create(:user_access, :action => 'index_' + @definition_category, :resource => 'project_misc_definitionx_misc_definitions', :masked_attrs => '-expire_date', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectMiscDefinitionx::MiscDefinition.scoped.order('ranking_index')")     
        
      user_access = FactoryGirl.create(:user_access, :action => 'create_' + @definition_category, :resource =>'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update_' + @definition_category, :resource =>'project_misc_definitionx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show_' + @definition_category, :resource =>'project_misc_definitionx_misc_definitions', :masked_attrs => '', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'destroy_' + @definition_category, :resource =>'project_misc_definitionx_misc_definitions', :masked_attrs => '', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_public_Misc Definition', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      qs1 = FactoryGirl.create(:project_misc_definitionx_misc_definition, :last_updated_by_id => @u.id, :project_id => @proj.id, :definition_category => @definition_category)
        
      visit misc_definitions_path(:project_id => @proj.id, :definition_category => @definition_category, :subaction => @definition_category )
      save_and_open_page
      page.should have_content('Misc Definitions')
      click_link 'Edit'
      page.should have_content('Update Misc Definition')
      save_and_open_page
      #fill_in 'misc_definition_name', :with => 'a test bom'
      #click_button 'Save'
      #with bad data
=begin  #need to enable js to test
      visit misc_definitions_path
      #save_and_open_page
      page.should have_content('Misc Definitions')
      click_link 'Edit'
      fill_in 'misc_definition_ranking_index', :with => ''
      click_button 'Save'
      save_and_open_page
=end      
      visit misc_definitions_path(:project_id => @proj.id, :definition_category => @definition_category, :subaction => @definition_category )
      save_and_open_page
      click_link qs1.name
      page.should have_content('Misc Definition Info')
            
      visit new_misc_definition_path(:definition_category => @definition_category, :project_id => @proj.id, :subaction => @definition_category)
      save_and_open_page
      page.should have_content('New Misc Definition')
=begin
      fill_in 'misc_definition_subject', :with => 'a test bom'
      fill_in 'misc_definition_content', :with => 'a test spec'
      fill_in 'misc_definition_start_date', :with => Date.today
      click_button 'Save'
      #save_and_open_page
      #with wrong data
      visit new_misc_definition_path
      fill_in 'misc_definition_subject', :with => ''
      fill_in 'misc_definition_content', :with => 'a test spec'
      fill_in 'misc_definition_start_date', :with => Date.today
      click_button 'Save'
      #save_and_open_page
=end      
    end
  end
end
