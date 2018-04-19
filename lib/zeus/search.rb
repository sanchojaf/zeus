require 'json'
require 'zeus/configuration'

# Search is a representation of a set of json files
# and an config file
# Is responsable to do queries to the documents
module Zeus
  class Search
    include Loader

    attr_reader :config, :resources, :path_directory

    # Initialize and instance of Resource
    # @param {String} full path directory
    def initialize(path_directory = nil)
      @path_directory = path_directory
      @config = Configuration.new(path_directory)
      @resources = []
      # call to a private file
      load!(path_directory)
    end

    # Return the first record that math with
    # resource <resource_name>, attr <attr> and value <value>
    # Include existing references in other documents
    # Initialize and instance of Resource
    # @param {String} resource_name The resource name.
    # @param {String} attr The attribute name.
    # @param {String} value The value.
    # @return {Hash, nil} a hash with the result or nil
    def find_by(resource_name, attr, value)
      # find the record in the file
      result = find_in_file(resource_name, attr, value)
      return nil if result.nil?
      # find the existen references in other files
      ref_results = find_references(resource_name, config.id_field, result[config.id_field])
      result.merge!(ref_results)
      result
    end

    # Return the resource with name <name>
    # Initialize and instance of Resource
    # @param {String} name The resource name.
    # @return {Resource} a resurce object
    def resource(name)
      resource_name = base_file_name(name)
      resources.detect { |re| re.name == resource_name }
    end

    # @return {Array<resource_name>} return the list of resorce names
    def list
      resources.map(&:name)
    end

    # @param {String} resource_name The resource name.
    # @return {Array<attr_name>} return the list of attributes for the resource
    def fields(resource_name)
      if (re = resource(resource_name))
        re.fields
      else
        nil
      end
    end

    private
      # Iterate for all the json files and create the Resource Objets
      # @param {String} full path directory
      def load!(path = nil)
        # pass a block to the method define in Loader
        each_json_file(path) do |file_path|
          next if File.basename(file_path) == File.basename(config.path)
          @resources << Resource.new(file_path)
        end
      end

      # find all the records in the resource
      # Return the first record that math with
      # resource <resource_name>, attr <attr> and value <value>
      # Include existing references in other documents
      # Initialize and instance of Resource
      # @param {String} resource_name The resource name.
      # @param {String} attr The attribute name.
      # @param {String} orig_id_value The value for the original _key.
      # @return {Hash, nil} a hash with all the referenes
      def find_references(resource_name, attr, orig_id_value)
        result = {}
        # use the references defined in config for the resource
        references = config.references(resource_name, attr)
        return result if references.nil? || references.empty?

        # find all records in others resources and merge
        references.each do |other_file, entry|
          merge_ref_values = []
          # acumulate all the records in others resource
          entry[config.ref_fields].each do |ref_attr|
            merge_ref_values += find_all(other_file, ref_attr, orig_id_value)
          end

          # merge all the records in others resources
          merge_ref_values.each_with_index do |item, i|
            # use the value of original name defined in entry
            original_name_field = entry[config.original_name_field]
            result["#{other_file}_#{i}"] = item[original_name_field]
          end
        end

        result
      end

      # find all the records in the resource <resource_name>
      # Return all the records that math with <attr> and <value>
      # Initialize and instance of Resource
      # @param {String} resource_name The resource name.
      # @param {String} attr The attribute name.
      # @param {String} value The value.
      # @return {Array} a array with the results
      def find_all(resource_name, attr, value)
        resource = resource(resource_name)
        resource.find_all(attr, value)
      end

      # find the first record in the resource <resource_name>
      # Return the first record that math with <attr> and <value>
      # Initialize and instance of Resource
      # @param {String} resource_name The resource name.
      # @param {String} attr The attribute name.
      # @param {String} value The value.
      # @return {Hash, nil} a hash with the result or nil
      def find_in_file(resource_name, attr, value)
        resource = resource(resource_name)
        return nil if resource.nil?
        resource.find_by(attr, value)
      end
  end
end
