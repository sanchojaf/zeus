require 'spec_helper'
require_relative '../../lib/zeus/configuration'


RSpec.describe 'Zeus::Configuration' do
  let(:config) { Zeus::Configuration.new }

  specify '.instance always refers to the same instance' do
  end
end
