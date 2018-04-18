require 'json'
require 'zeus/loader'

module Zeus
  class Resource
    include Zeus::Loader
    attr_reader :name, :data_hash, :fields, :path

    def initialize(path)
      @name = base_file_name(path)
      @path = path
      @data_hash = load_json_file!(@path)
      load_fields!
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
        @fields = attributes.keys
      end

  end
end
