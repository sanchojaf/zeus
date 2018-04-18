require 'spec_helper'
require 'zeus/cli'

RSpec.describe Zeus::CLI.new(path: File.dirname(File.dirname(File.absolute_path(__FILE__))) + '/support/jsons') do
  context "help" do
    let(:output) { capture(:stdout) { subject.help } }

    it "returns a commands" do
      expect(output).to include("rspec fields")
      expect(output).to include("rspec help")
      expect(output).to include("rspec find_by")
      expect(output).to include("rspec list")
    end
  end

  context "list" do
    let(:output) { capture(:stdout) { subject.list } }

    it "returns a commands" do
      expect(output).to include("List json files in the current directory:")
      expect(output).to include("organizations")
      expect(output).to include("users")
      expect(output).to include("tickets")
    end
  end

  context "fields" do
    let(:output) { capture(:stdout) { subject.fields 'users' } }

    it "returns a commands" do
      expect(output).to be_truthy
    end
  end

end
