require 'zeus/loader'
module Zeus
  class Configuration
    include Loader

    attr_reader :meta_hash, :meta_file_name, :path

    META_FILE = 'zeus.json'

    # Initialize and instance of Configuration
    # @param {String} full path
    def initialize(path = nil)
      # default path is the current directory
      path ||= './'
      name =  File.file?(path) ? File.basename(path) : META_FILE
      # name wihtout the extension eg, my_file.json => my_file
      @meta_file_name = base_file_name(name)
      # if is a path directory then need add the file name to the path
      path = File.join(path,"#{@meta_file_name}.json") if File.directory?(path)
      @path = path
      # load the metafile in a hash
      @meta_hash = load_json_file!(@path)
    end

    # Find if exists references (foreign keys) for a partircular resouce attribute
    # in other files.
    #
    # The next example define `submitter_id` in `tickets.json` as foreign keys
    # of '_id' in users.json
=begin
    # zeus.json
    {
      "resources": {
        "users": {
          "fields": {
            "_id": {
              "references": {
                "tickets": {
                  "display_field": "subject",
                    "ref_fields": [
                      "submitter_id"]}}}}}}}
=end
    # @param {String} resource_name The name of the resorce.
    # @param {String} attr The attribute name.
    # @return {Boolean} true if exist, false if not
    def references?(resource_name, attr)
      !(entry_resource = meta_hash['resources'][resource_name]).nil? &&
        !(entry_resource['fields'][attr]).nil?
    end

    # return if exists the references for a partircular resouce attribute
    # in other files.
    # return nil if not exist
    # @param {String} resource_name The name of the resorce.
    # @param {String} attr The attribute name.
    # @return {Hash, nil} a hash with the result or nil
    def references(resource_name, attr)
      ['resources',resource_name,'fields', attr,'references'].inject(meta_hash) {|m,k| m && m[k]}
    end

    # @return {String} return name for id_field
    def id_field
      '_id'
    end

    # @return {String} return name for ref_fields
    def ref_fields
      'ref_fields'
    end

    # @return {String} return name for ref_fields
    def original_name_field
      'original_name_field'
    end
  end
end
