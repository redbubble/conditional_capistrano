require 'conditional_capistrano/capistrano/task_definition'

module ConditionalCapistrano
  module Capistrano
    def self.included(base)
      base.class_eval do
        include InstanceMethods

        alias_method :execute_task_without_paths_check, :execute_task
        alias_method :execute_task, :execute_task_with_paths_check
      end
    end

    module InstanceMethods
      def execute_task_with_paths_check(task)
        return if task.check_for_path_changes? && !trigger?(task)

        execute_task_without_paths_check task
      end

      def trigger?(task)
        task.paths_to_check.find { |path| changed_files.find { |p| p[0, path.length] == path } }
      rescue IndexError
        false
      end

    private

      def changed_files
        capture(
          "cd #{repository_cache} && git diff --name-only #{current_git_tag} HEAD | cat"
        ).strip.split
      end
    end
  end
end

Capistrano::Configuration.send :include, ConditionalCapistrano::Capistrano
