module ConditionalCapistrano
  module Capistrano
    module TaskDefinition
      def self.included(base)
        base.class_eval do
          include InstanceMethods
        end
      end

      module InstanceMethods
        def check_for_path_changes?
          options.has_key? :when_changed
        end

        def paths_to_check
          Array options[:when_changed]
        end
      end
    end
  end
end

Capistrano::TaskDefinition.send :include, ConditionalCapistrano::Capistrano::TaskDefinition
