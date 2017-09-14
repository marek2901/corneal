require 'thor/group'
require 'active_support/inflector'

module Corneal
  module Generators
    class ApiControllerGenerator < Thor::Group
      include Thor::Actions
      attr_reader :controller_name, :class_name, :file_name

      desc 'Generate an API Controller responding with JSON'
      argument :name, type: :string, desc: 'Name of the controller'

      def self.source_root
        File.dirname(__FILE__)
      end

      def setup
        @controller_name = name.pluralize.underscore
        @class_name      = "#{controller_name.camel_case}Controller"
        @file_name       = class_name.underscore
      end

      def create_controller
        template 'templates/controller.rb.erb',
                 File.join('app/controllers', "#{file_name}.rb")
        insert_into_file 'config.ru', "use #{class_name}\n",
                         after: "run ApplicationController\n"
      end
    end
  end
end
