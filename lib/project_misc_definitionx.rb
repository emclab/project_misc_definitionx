require "project_misc_definitionx/engine"

module ProjectMiscDefinitionx
  mattr_accessor :project_class, :project_class_string
  def self.project_class
    @@project_class.constantize
  end
end
