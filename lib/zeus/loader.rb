require 'json'

module Zeus
  module Loader

    def load_json_file!(file_name, path = nil)
      file_name += '.json' unless file_name =~ /\.json$/
      full_path = ''
      if path
        full_path = "#{path}/#{file_name}"
      else
        full_path = File.join(
            File.dirname(File.dirname(File.absolute_path(__FILE__))),
            file_name)
      end
      # return data_hash unless data_hash.nil?
      file = File.read(full_path)
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
      path ||= '**'
      path += '/*.json'
      Dir[path].each do |json_file_name|
        split_path = json_file_name.split(File::SEPARATOR)
        file_name = base_file_name(split_path[-1])
        file_path = split_path.size < 1 ? nil : split_path[0..-2].join(File::SEPARATOR)
        yield file_name, file_path
      end
    end
  end
end
