require 'spec_helper'
require_relative '../../lib/zeus/resource'

RSpec.describe 'Zeus::Resource' do
  let(:path_directory) do
    File.dirname(File.dirname(File.absolute_path(__FILE__))) + '/support/jsons'
  end

  let(:search) { Zeus::Search.new(path_directory) }

  context "#list" do

    it 'should include' do
      expect(search.list).to include("organizations")
      expect(search.list).to include("users")
      expect(search.list).to include("tickets")
    end

    it 'should not include' do
      expect(search.list).not_to include("zeus")
    end
  end

  context "#find_by in users 71" do
    let(:fragment_user_id_71) do
      {
        "_id" => 71,
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

  context "#find_by organization _id 119" do
    let(:fragment_organization_id_119) do
      {
        "_id" => 119,
        "tickets_0" => "A Nuisance in Bangladesh",
        "tickets_1" => "A Catastrophe in San Marino",
        "tickets_2" => "A Drama in Chad",
        "tickets_3" => "A Problem in Guatemala",
        "tickets_4" => "A Nuisance in Suriname",
        "tickets_5" => "A Catastrophe in Thailand",
        "tickets_6" => "A Drama in Nigeria",
        "users_0" => "Francisca Rasmussen",
        "users_1" => "Pitts Park",
        "users_2" => "Moran Daniels",
        "users_3" => "Catalina Simpson"
      }
    end

    it 'find_by should return an Hash' do
      expect(search.find_by('organizations','_id', 119)).to be_kind_of Hash
    end

    it 'find_by should return an Hash' do
      expect(search.find_by('organizations','_id', 119)).to include(fragment_organization_id_119)
    end
  end

end
