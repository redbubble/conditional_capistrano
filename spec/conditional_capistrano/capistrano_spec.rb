module Capistrano; end
module Capistrano
  class Configuration
    def execute_task(task)
      "original"
    end
  end
end

module Capistrano
  class TaskDefinition
  end
end

require 'conditional_capistrano/capistrano'

describe Capistrano::Configuration do

  describe "#applies_to_with_paths_check?" do
    let(:task) { Capistrano::TaskDefinition.new }

    it "falls back to the original if this task doesn't require a path check" do
      task.stub :check_for_path_changes? => false
      subject.execute_task(task).should == "original"
    end

    context "when path check is required" do
      before do
        task.stub :check_for_path_changes? => true
      end

      it "returns false if files have been specified, but haven't changed" do
        subject.stub :trigger? => false
        subject.execute_task(task).should_not be
      end

      it "falls back to the original if files have been specified, and have changed" do
        subject.stub :trigger? => true
        subject.execute_task(task).should == "original"
      end
    end
  end

  describe "#trigger?" do
    let(:task) { Capistrano::TaskDefinition.new }

    it "returns false if the task doesn't have any paths to check" do
      task.stub paths_to_check: []
      subject.trigger?(task).should_not be
    end

    it "returns false if no files have changed" do
      task.stub paths_to_check: %w[path/to/file]
      subject.stub changed_files_in_git: []

      subject.trigger?(task).should_not be
    end

    it "returns true if we have matching files" do
      task.stub paths_to_check: %w[path/to/file]
      subject.stub changed_files_in_git: %w[path/to/file]

      subject.trigger?(task).should be
    end

    it "returns false if we files that don't match" do
      task.stub paths_to_check: %w[path/to/file1]
      subject.stub changed_files_in_git: %w[path/to/file2]

      subject.trigger?(task).should_not be
    end

    it "returns true if we have files that match a path" do
      task.stub paths_to_check: %w[path/to]
      subject.stub changed_files_in_git: %w[path/to/file]

      subject.trigger?(task).should be
    end

    it "returns false if we have files that match a path with a dot" do
      task.stub paths_to_check: %w[path/to.test]
      subject.stub changed_files_in_git: %w[path/to-test/file]

      subject.trigger?(task).should_not be
    end
  end
end
