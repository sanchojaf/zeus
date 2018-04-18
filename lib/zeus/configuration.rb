require 'zeus/loader'
module Zeus
  class Configuration
    include Loader

    attr_reader :meta_hash, :meta_file_name, :path

    META_FILE = 'zeus.json'

    def initialize(path = nil)
      @meta_file_name = base_file_name(META_FILE)
      path ||= './'
      path = File.join(path,"#{@meta_file_name}.json") if File.directory?(path)
      @path = Dir[path].first
      @meta_hash = load_json_file!(@path)
    end

    def references?(resource_name, attr)
      !(entry_resource = meta_hash['resources'][resource_name]).nil? &&
        !(entry_resource['fields'][attr]).nil?
    end

    def references(resource_name, attr)
      ['resources',resource_name,'fields', attr,'references'].inject(meta_hash) {|m,k| m && m[k]}
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

    private
      def load!(path = nil)
        each_json_file(path) do |file_name, file_path|
          next if file_name != meta_file_name
          @meta_hash = load_json_file!(file_name, file_path)
          break
        end
      end

  end
end
