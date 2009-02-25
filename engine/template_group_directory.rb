require 'engine/engine'

module Slippers
  class TemplateGroupDirectory < TemplateGroup
    def initialize(directory_path, params={})
      @directory_path = directory_path
      @super_group = params[:super_group]
    end
    attr_reader :directory_path
    
    def find(subtemplate)

      file_name = @directory_path + '/' + subtemplate + '.st'
      return find_renderer(subtemplate) unless File.exist?(file_name)
      Engine.new(FileTemplate.new(file_name).template, :template_group => self)
      
    end
    
    def eql?(other)
      return false unless other
      directory_path.eql?(other.directory_path)
    end
    def hash
      @directory_path.hash
    end
    
    private
      def find_renderer(subtemplate)
        file_name = @directory_path + '/' + subtemplate + '.rb'
        return find_in_super_group(subtemplate) unless File.exist?(file_name)
        renderer_name = subtemplate.split('/')[-1]
        load File.expand_path(file_name)
        renderer_name.camelize.constantize.new
      end
      
      def find_in_super_group(subtemplate)
        return nil unless @super_group 
        @super_group.find(subtemplate)
      end
  end
end