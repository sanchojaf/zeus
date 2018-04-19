require 'json'
require 'zeus/loader'

# Resource is a representation of a json file
#
# Load the json file as a hash
# Is responsable to do queries to document
module Zeus
  class Resource
    include Zeus::Loader
    attr_reader :name, :data_hash, :fields, :path

    # Initialize and instance of Resource
    # @param {String} full path
    def initialize(path)
      @name = base_file_name(path)
      @path = path
      @data_hash = load_json_file!(@path)
      load_fields!
    end

    # Return the first record that math with <attr> and <value>
    # Initialize and instance of Resource
    # @param {String} attr The attribute name.
    # @param {String} value The value.
    # @return {Hash, nil} a hash with the result or nil
    def find_by(attr, value)
      data_hash.find { |entry| entry[attr].to_s == value.to_s }
    end

    # Return all the records that math with <attr> and <value>
    # Initialize and instance of Resource
    # @param {String} attr The attribute name.
    # @param {String} value The value.
    # @return {Array} a array with the results
    def find_all(attr, value)
      data_hash.select { |entry| entry[attr].to_s == value.to_s }
    end

    private

      # Iterate all the records, and acumulate all the atrributes
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
