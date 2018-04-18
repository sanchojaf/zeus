require 'json'

module Zeus
  module Loader

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

    def base_file_name(file_name)
      file_name = File.basename(file_name)
      if (short_name = file_name[/(.+)\.json$/,1])
        file_name = short_name
      end
      file_name
    end

    def each_json_file(path = nil)
      path ||= './'
      path += '/*.json'
      Dir[path].each do |path_name|
        yield path_name
      end
    end
  end
end
