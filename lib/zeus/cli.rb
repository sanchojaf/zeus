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

    # Hack to allow initialize with a directory path
    # In particular is useful for rspec
    # after copy and delete from parameter before call super
    if args[0].is_a?(Hash) && args[0].key?(:path)
      path = args[0][:path]
      args.shift
    end

    super
    @searcher = Search.new(path)
  end

  desc "find_by [file_name, attr, value]", "find by attr for a value"
  long_desc <<~FIND_BY
    `find_by users _id 71` will print out the first record with field <_id>
     value <71> for file <users.json>.

     users.json should exist in the directory

     Values from any related entities could be included in the results
     if exist a zeus.json file with the specifications for foreign keys:

     The next example define `submitter_id` in `tickets.json` as foreign keys
     of '_id' in users.json

     {"resources":{"users":{"fields":{"_id":"references":{"tickets":{"original_name_field":"subject","ref_fields":["submitter_id"]}}}}}}

     Example 1:

     This example do not define a file zeus.json

     Then `find_by users _id 71` return the info in 'users.json' and not include any references from external file.

     here the an example details:

     {\n
       "_id": 71,\n
       "url": "http://initech.zendesk.com/api/v2/users/71.json",\n
       "external_id": "c972bb41-94aa-4f20-bc93-e63dbfe8d9ca",\n
       "name": "Prince Hinton",\n
       "alias": "Miss Dana",\n
       "created_at": "2016-04-18T11:05:43 -10:00",\n
       "active": true,\n
       "verified": false,\n
       "shared": false,\n
       "locale": "zh-CN",\n
       "timezone": "Samoa",\n
       "last_login_at": "2013-05-01T01:18:48 -10:00",\n
       "email": "danahinton@flotonic.com",\n
       "phone": "9064-433-892",\n
       "signature": "Don't Worry Be Happy!",\n
       "organization_id": 121,\n
         "tags": [\n
           "Davenport",\n
           "Cherokee",\n
           "Summertown",\n
           "Clinton"\n
         ],\n
       "suspended": false,\n
       "role": "agent"\n
     }\n

     Example 2:

     This example define `submitter_id` in `tickets.json`, as foreign keys of `_id' in users.json

     Result for `zeus find_by users _id 71` should include the references in the next format:

     "_id": 71\n
     ...\n
     "tickets_0": "A Catastrophe in Micronesia"\n
     "tickets_1": "A Drama in Wallis and Futuna Islands"\n
     "tickets_2": "A Drama in Australia"


     Example 3:

     This example define `organization_id` in `tickets.json` and `users.json`, as foreign keys for `_id' in organization.json

     {"resources": {"organizations": {"fields": {"_id": {"references": {
        "users": {"original_name_field": "name","ref_fields": ["organization_id"]},
        "tickets": {"original_name_field": "subject","ref_fields": ["organization_id"]}}}}}}}

     Result for `zeus find_by organizations _id 119` should include the references in the next format:

     "_id": 119\n
     ...\n
     "users_0": "Francisca Rasmussen"\n
     "users_1": "Pitts Park"\n
     "users_2": "Moran Daniels"\n
     "users_3": "Catalina Simpson"\n
     "tickets_0": "A Nuisance in Bangladesh"\n
     "tickets_1": "A Catastrophe in San Marino"\n
     "tickets_2": "A Drama in Chad"\n
     "tickets_3": "A Problem in Guatemala"\n
     "tickets_4": "A Nuisance in Suriname"\n
     "tickets_5": "A Catastrophe in Thailand"\n
     "tickets_6": "A Drama in Nigeria"\n
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
    puts searcher.list
  end

  desc "fields [file_name]", "List of searchable fields of a json file"
  def fields(file_name)
    result = searcher.fields(file_name)
    if result
      puts "List of searchable fields in #{file_name}:"
      puts result
    else
      puts "No file found for #{file_name}"
    end
  end

 end
end
