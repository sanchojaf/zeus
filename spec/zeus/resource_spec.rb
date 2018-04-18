require 'spec_helper'
require_relative '../../lib/zeus/resource'

RSpec.describe 'Zeus::Resource' do
  let(:path) do
    File.dirname(File.dirname(File.absolute_path(__FILE__))) + '/support/jsons/users.json'
  end
  let(:users) { Zeus::Resource.new(path) }

  specify '#fields' do
    expected = [
      "_id",
      "url",
      "external_id",
      "name",
      "alias",
      "created_at",
      "active",
      "verified",
      "shared",
      "locale",
      "timezone",
      "last_login_at",
      "email",
      "phone",
      "signature",
      "organization_id",
      "tags",
      "suspended",
      "role"]
    expect(users.fields).to match(expected)
  end

  context "#find_by" do
    let(:id_71) do
      { "_id" => 71,
        "active" => true,
        "alias" => "Miss Dana",
        "created_at" => "2016-04-18T11:05:43 -10:00",
        "email" => "danahinton@flotonic.com",
        "external_id" => "c972bb41-94aa-4f20-bc93-e63dbfe8d9ca",
        "last_login_at" => "2013-05-01T01:18:48 -10:00",
        "locale" => "zh-CN",
        "name" => "Prince Hinton",
        "organization_id" => 121,
        "phone" => "9064-433-892",
        "role" => "agent",
        "shared" => false,
        "signature" => "Don't Worry Be Happy!",
        "suspended" => false,
        "tags" => ["Davenport", "Cherokee", "Summertown", "Clinton"],
        "timezone" => "Samoa",
        "url" => "http://initech.zendesk.com/api/v2/users/71.json",
        "verified" => false}
    end

    it 'find_by should return an Hash' do
      expect(users.find_by('_id', 71)).to be_kind_of Hash
    end

    specify '#data_hash' do
      expect(users.data_hash).to include(id_71)
    end

    it 'find_by should return all the record' do
      expect(users.find_by('_id', 71)).to match(id_71)
    end
  end

  context "#find_all" do
    it 'find_by should return an Array' do
      expect(users.find_all('_id', 71)).to be_kind_of Array
    end

    it 'find_all should return one element if attribute values are unique' do
      expect(users.find_all('_id', 71).size).to be == 1
    end

    specify 'find_all should return all the elment that match' do
      expect(users.find_all('active', true).size).to be > 30
    end
  end

end
