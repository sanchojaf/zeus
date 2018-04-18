# Zeus

Zeus! Is a CLI to made simple queries to JSON files.

# Commands:    
  zeus fields [file_name]                # List of searchable fields of a json file
  zeus find_by [file_name, attr, value]  # find by an attribute and a value
  zeus help [COMMAND]                    # Describe available commands or one specific
                                         # command
  zeus list                              # List of json files in the current directory

## Installation

Clone the repository:

```shell
# clone the repo

# using ssh
$ git clone git@github.com:sanchojaf/zeus.git

# using https
$ git clone https://github.com/sanchojaf/zeus.git
```

Move to the root folder

`$ cd zeus`

The exe directive we used to create the gem, generated a zeus binary from the project. Change the permissions so we can execute the file:

`$ chmod +x exe/zeus`

Now, we are able to call it:

`$ bundle exec exe/zeus help`

But in way we are limited to use in the root of the project folder.

To use in any folder, install the gem locally using rake.

`$ bundle exec rake install`

Now we can use the Zeus CLI like any other command line in shell.

Call it:

`zeus help`

## requirements

dependencies
- ruby
- bundler
- rake
- rspec

Was implemented and tested with `ruby-2.3.0` but you should be able to use other version of ruby.

## Assumptions

Files should be similar to the examples files that we have for testing

[sample jsons](spec/support/jsons)

## Usage

`zeus find_by [file_name, attr, value]`

Description:  

`find_by users _id 71` will print out the record field `_id` value `71` for file <users.json>.

users.json should exist in the directory

Values from any related entities are included in the results only if exist a zeus.json file with the specification for foreign keys:

The next example define `submitter_id` in `tickets.json` as foreign keys of `_id' in users.json

```ruby
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

Bug reports and pull requests are welcome on GitHub at https://github.com/sanchojaf/zeus
