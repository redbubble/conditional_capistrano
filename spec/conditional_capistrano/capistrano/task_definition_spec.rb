module Capistrano; end
module Capistrano
  class TaskDefinition
    attr_reader :options
  end
end

require 'conditional_capistrano/capistrano/task_definition'

describe Capistrano::TaskDefinition do

  describe "#check_for_path_changes?" do
    it "returns true if no 'when_changed' options are present" do
      subject.stub :options => {}
      subject.check_for_path_changes?.should_not be
    end

    it "returns false if 'when_changed' options are present" do
      subject.stub :options => { when_changed: "path" }
      subject.check_for_path_changes?.should be
    end
  end
end
