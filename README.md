# Zeus

Zeus! Queries on JSON files

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zeus'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zeus


# Commands:    
  zeus fields [file_name]                # List of searchable fields of a json file
  zeus find_by [file_name, attr, value]  # find by attr for a value
  zeus help [COMMAND]                    # Describe available commands or one specific command
  zeus list                              # List json files in the current directory

## Usage

`zeus find_by [file_name, attr, value]`

Description:  

`find_by users _id 71` will print out the record field `_id` value `71` for file <users.json>.

users.json should exist in the directory

Values from any related entities are included in the results only if exist a zeus.json file with the specification for foreign keys:

The next example define `submitter_id` in `tickets.json` as foreign keys of `_id' in users.json

```json
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
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/zeus.
