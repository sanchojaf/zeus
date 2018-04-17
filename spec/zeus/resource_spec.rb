require 'spec_helper'
require_relative '../../lib/zeus/resource'


RSpec.describe 'Zeus::Resource' do
  let(:config) { Zeus::Resource.instance }

  specify '.instance always refers to the same instance' do
    expect(Zeus::Resource.instance).to be_a_kind_of Zeus::Resource
    expect(Zeus::Resource.instance).to eq config
  end
end
