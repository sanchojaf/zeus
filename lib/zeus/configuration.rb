require 'zeus/loader'
module Zeus
  class Configuration
    include Loader

    attr_accessor :meta_hash, :meta_file_name

    META_FILE = 'zeus.json'

    def initialize
      @meta_file_name = META_FILE
      @meta_hash = load_json_file!(META_FILE)
    end

    def references?(resource_name, attr)
      !(entry_resource = meta_hash['resources'][resource_name]).nil? &&
        !(entry_resource['fields'][attr]).nil?
    end

    def references(resource_name, attr)
      meta_hash['resources'][resource_name]['fields'][attr]['references']
    end

    def id_field
      '_id'
    end

    def ref_fields
      'ref_fields'
    end

    def original_name_field
      'original_name_field'
    end
  end
end
