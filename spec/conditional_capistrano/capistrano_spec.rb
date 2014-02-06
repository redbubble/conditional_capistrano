module Capistrano; end
class Capistrano::Callback
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def applies_to?(task)
    "original"
  end
end

require 'conditional_capistrano/capistrano'

describe Capistrano::Callback do

  describe "#applies_to_with_file_check?" do
    it "falls back to the original 'applies_to?' if no 'when_changed' options were found" do
      Capistrano::Callback.new({}).applies_to?("test").should == "original"
    end

    it "returns false if files have been specified, but haven't changed" do
      callback = Capistrano::Callback.new(when_changed: "file")
      callback.stub :trigger? => false

      callback.applies_to?("test").should_not be
    end

    it "falls back to the original if files have been specified, and have changed" do
      callback = Capistrano::Callback.new(when_changed: "file")
      callback.stub :trigger? => true

      callback.applies_to?("test").should == "original"
    end

    context "possible file options" do
      it "allows a single file" do
        callback = Capistrano::Callback.new(when_changed: "file")

        callback.should_receive(:trigger?).with "file"
        callback.applies_to? "test"
      end

      it "allows an array of files" do
        callback = Capistrano::Callback.new(when_changed: %w[file1 file2])

        callback.should_receive(:trigger?).with "file1", "file2"
        callback.applies_to? "test"
      end
    end
  end
end
