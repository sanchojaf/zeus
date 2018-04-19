require 'spec_helper'
require_relative '../../lib/zeus/configuration'

RSpec.describe 'Zeus::Configuration' do
  let(:path) do
    File.dirname(File.dirname(File.absolute_path(__FILE__))) + '/support/jsons/zeus.json'
  end
  let(:config) { Zeus::Configuration.new(path) }

  specify '#meta_hash' do
    expected =
    {"resources"=>
      {"users"=>
        {"fields"=>
          {"_id"=>
            {"references"=>
              {"tickets"=>
                {"original_name_field"=>"subject",
                 "ref_fields"=>["submitter_id"]}}}}},
       "organizations"=>
        {"fields"=>
          {"_id"=>
            {"references"=>
              {"users"=>
                {"original_name_field"=>"name", "ref_fields"=>["organization_id"]},
               "tickets"=>
                {"original_name_field"=>"subject",
                 "ref_fields"=>["organization_id"]}}}}}}}
    expect(config.meta_hash).to match(expected)
  end

  specify '#id_field' do
    expect(config.id_field).to match('_id')
  end

  specify '#ref_fields' do
    expect(config.ref_fields).to match('ref_fields')
  end

  specify '#original_name_field' do
    expect(config.original_name_field).to match('riginal_name_field')
  end

  context "references" do
    specify "sample user references" do
      user_references = config.references('users', '_id')
      expected = {"tickets"=>{"original_name_field"=>"subject", "ref_fields"=>["submitter_id"]}}
      expect(user_references).to eq(expected)
    end

    specify "sample organizations references" do
      user_references = config.references('organizations', '_id')
      expected = {"users"=>{"original_name_field"=>"name", "ref_fields"=>["organization_id"]}, "tickets"=>{"original_name_field"=>"subject", "ref_fields"=>["organization_id"]}}
      expect(user_references).to eq(expected)
    end
  end
end
