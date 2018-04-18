require 'spec_helper'
require_relative '../../lib/zeus/resource'

RSpec.describe 'Zeus::Resource' do
  let(:path_directory) do
    File.dirname(File.dirname(File.absolute_path(__FILE__))) + '/support/jsons'
  end

  let(:search) { Zeus::Search.new(path_directory) }

  context "#find_by" do
    let(:fragment_user_id_71) do
      {
        "tickets_0" => "A Catastrophe in Micronesia",
        "tickets_1" => "A Drama in Wallis and Futuna Islands",
        "tickets_2" => "A Drama in Australia",
      }
    end

    it 'find_by should return an Hash' do
      expect(search.find_by('users','_id', 71)).to be_kind_of Hash
    end

    it 'find_by should return an Hash' do
      expect(search.find_by('users','_id', 71)).to include(fragment_user_id_71)
    end

  end
end
