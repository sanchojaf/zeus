require 'json'

module Zeus
  module Loader
    def load_json_file!(file_name, path = nil)
      # return data_hash unless data_hash.nil?
      file = File.read(file_name)
      # self.data_hash =
      JSON.parse(file)
    end

    def base_file_name(file_name)
      if (short_name = file_name[/(.+)\.json$/,1])
        file_name = short_name
      end
      file_name
    end

    def each_json_file(path = nil)
      path ||= "**/*.json"
      Dir[path].each do |json_file_name|
        yield json_file_name
      end
    end
  end
end
