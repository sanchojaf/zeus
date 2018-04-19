require 'json'

# Loader is a module simplify
# operation with files
module Zeus
  module Loader

    # Read an parse json file
    # @param {String} full path
    def load_json_file!(path)
      return nil if path.nil?
      begin
        # return data_hash unless data_hash.nil?
        file = File.read(path)
        # self.data_hash =
        JSON.parse(file)
      rescue Errno::ENOENT => ex
        {}
      end
    end

    # name wihtout the directory path or extension
    # eg, my_file.json => my_file
    # @param {String} file_name
    def base_file_name(file_name)
      file_name = File.basename(file_name)
      if (short_name = file_name[/(.+)\.json$/,1])
        file_name = short_name
      end
      file_name
    end

    # Allow iterate the json file a directory
    # @param {String} directory_path path
    def each_json_file(directory_path = nil)
      directory_path ||= './'
      directory_path += '/*.json'
      Dir[directory_path].each do |path_name|
        yield path_name
      end
    end
  end
end
