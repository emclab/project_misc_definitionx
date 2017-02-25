FactoryGirl.define do
  factory :commonx_search_stat_meta_config, class: 'Commonx::SearchStatMetaConfig' do
    resource_name "MyString"
    stat_summary_function "MyText"
    search_summary_function "MyText"
    labels_and_fields "MyText"
    time_frame "MyText"
    stat_header "MyText"
    fort_token "MyString"
    last_updated_by_id 1
  end
end
