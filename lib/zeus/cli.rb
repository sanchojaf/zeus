require 'thor'
require 'zeus/search'
require 'zeus/resource'
require 'zeus/configuration'

# The command line interface for {Zeus}.
#
# See the source or the command line tool `bin/zeus` for more
# information
module Zeus
 class CLI < Thor
  include Thor::Actions
  attr_reader :searcher

  def initialize(*args)
    if args[0].is_a?(Hash) && args[0].key?(:path)
      path = args[0][:path]
      args.shift
    end
    super
    @searcher = Search.new(path)
  end

  desc "find_by [file_name, attr, value]", "find by attr for a value"
  long_desc <<~FIND_BY
    `find_by users _id 71` will print out the record field
     <_id> value <71> for file <users.json>.

     users.json should exist in the directory

     Values from any related entities are included in the results
     only if exist a zeus.json file with the specification for foreign keys:

     The next example define `submitter_id` in `tickets.json` as foreign keys
     of '_id' in users.json

     "resources":{"users":{"fields":{"_id":"references":{"tickets":{"original_name_field":"subject","ref_fields":["submitter_id"]}}}}}
    FIND_BY
  def find_by(file_name, attr, value)
    result = searcher.find_by(file_name, attr, value)
    if result
      puts JSON.pretty_generate(result)
    else
      puts "Searching #{file_name} for #{attr} with a value of #{value} \n No results found"
    end
  end

  desc "list", "List json files in the current directory"
  def list
    puts "List json files in the current directory:"
    puts searcher.resources.map(&:name)
  end

  desc "fields [file_name]", "List of searchable fields of a json file"
  def fields(file_name)
    if (resource = searcher.resource(file_name))
      puts "List of searchable fields in #{file_name}:"
      puts resource.fields
    else
      puts "No file found for #{file_name}"
    end
  end

 end
end
