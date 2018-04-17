require 'json'
require 'zeus/loader'

module Zeus
  class Resource
    include Zeus::Loader
    attr_accessor :file_name, :data_hash, :fields

    def initialize(file_name)
      file_name += '.json' unless file_name =~ /\.json$/
      @file_name = file_name
      @data_hash = load_json_file!(file_name)
      load_fields!
    end

    def name
      base_file_name(file_name)
    end

    def find_by(attr, value)
      data_hash.find { |entry| entry[attr].to_s == value.to_s }
    end

    def find_all(attr, value)
      data_hash.select { |entry| entry[attr].to_s == value.to_s }
    end

    private
      def load_fields!
        attributes = {}
        data_hash.each do |entry|
          next unless entry.is_a? Hash
          entry.keys.each { |key| attributes[key] ||= nil }
        end
        self.fields = attributes.keys
      end

  end
end
