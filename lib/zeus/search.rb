require 'json'
require 'zeus/configuration'

module Zeus
  class Search
    include Loader

    attr_reader :config, :resources

    def initialize
      @config = Zeus::Configuration.new
      @resources = []
      load!
    end

    def find_by(resource_name, attr, value)
      result = find_in_file(resource_name, attr, value)
      ref_results = find_references(resource_name, config.id_field, result[config.id_field])
      result.merge!(ref_results)
      result
    end

    private

      def resource(name)
        resource_name = base_file_name(name)
        resources.detect { |re| re.name == resource_name }
      end

      def load!
        each_json_file do |json_file_name|
          next if json_file_name == config.meta_file_name
          self.resources << Resource.new(json_file_name)
        end
      end

      def find_references(resource_name, attr, orig_id_value)
        result = {}
        references = config.references(resource_name, attr)
        return result if references.empty?


        references.each do |other_file, entry|

          merge_ref_values = []
          entry[config.ref_fields].each do |ref_attr|
            merge_ref_values += find_all(other_file, ref_attr, orig_id_value)
          end
          merge_ref_values.each_with_index do |item, i|
            original_name_field = entry[config.original_name_field]
            result["#{other_file}_#{i}"] = item[original_name_field]
          end
        end

        result
      end

      def find_all(resource_name, attr, value)
        resource = resource(resource_name)
        resource.find_all(attr, value)
      end

      def find_in_file(resource_name, attr, value)
        resource = resource(resource_name)
        resource.find_by(attr, value)
      end
  end
end
