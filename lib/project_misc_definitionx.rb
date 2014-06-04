require "project_misc_definitionx/engine"

module ProjectMiscDefinitionx
  mattr_accessor :project_class
  def self.project_class
    @@project_class.constantize
  end
end
