module ConditionalCapistrano
  module Capistrano
    def self.included(base)
      base.class_eval do
        include InstanceMethods

        alias_method :applies_to_without_file_check?, :applies_to?
        alias_method :applies_to?, :applies_to_with_file_check?
      end
    end

    module InstanceMethods
      def applies_to_with_file_check?(task)
        return false if check_for_changes? && !trigger?(*paths_to_check)

        applies_to_without_file_check?(task)
      end

    private

      def check_for_changes?
        options.has_key?(:when_changed)
      end

      def paths_to_check
        Array(options[:when_changed])
      end

      def trigger?(*paths)
        paths.find { |path| changed_files.find { |p| p[0, path.length] == path } }
      rescue IndexError
        false
      end

      def changed_files
        @changed_files ||=
          config.capture(
            "cd #{fetch(:repository_cache)} && git diff --name-only #{fetch(:current_git_tag)} HEAD | cat"
          ).strip.split
      end

      def fetch(key)
        config.fetch key
      end
    end
  end
end

Capistrano::Callback.send :include, ConditionalCapistrano::Capistrano
