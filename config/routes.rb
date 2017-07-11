ProjectMiscDefinitionx::Engine.routes.draw do
  resources :misc_definitions do
    collection do
      get :multi_csv
      get :multi_csv_result
    end
  end

end
