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

The exe directive used to create the gem, generated a zeus binary from the project. Change the permissions so we can execute the file:

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

### Example 1

This example do not define a file zeus.json

Then `find_by users _id 71` return the info in 'users.json' and not include any references from external file.

here the an example details:

```ruby
{
  "_id": 71,
  "url": "http://initech.zendesk.com/api/v2/users/71.json",
  "external_id": "c972bb41-94aa-4f20-bc93-e63dbfe8d9ca",
  "name": "Prince Hinton",
  "alias": "Miss Dana",
  "created_at": "2016-04-18T11:05:43 -10:00",
  "active": true,
  "verified": false,
  "shared": false,
  "locale": "zh-CN",
  "timezone": "Samoa",
  "last_login_at": "2013-05-01T01:18:48 -10:00",
  "email": "danahinton@flotonic.com",
  "phone": "9064-433-892",
  "signature": "Don't Worry Be Happy!",
  "organization_id": 121,
  "tags": [
    "Davenport",
    "Cherokee",
    "Summertown",
    "Clinton"
  ],
  "suspended": false,
  "role": "agent"
}
```

### Example 2

This example define `submitter_id` in `tickets.json`, as foreign keys of `_id' in users.json

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

Result for `zeus find_by users _id 71` should include the references in the next format:

```ruby
{
  "_id": 71,
  "url": "http://initech.zendesk.com/api/v2/users/71.json",
  ...
  "tickets_0": "A Catastrophe in Micronesia",
  "tickets_1": "A Drama in Wallis and Futuna Islands",
  "tickets_2": "A Drama in Australia"
}
```

### Example 3

This example define `organization_id` in `tickets.json` and `users.json`, as foreign keys for `_id' in organization.json

```ruby
{
  "resources": {
    "organizations": {
      "fields": {
        "_id": {
          "references": {
            "users": {
              "original_name_field": "name",
              "ref_fields": [
                "organization_id"]},
            "tickets": {
              "original_name_field": "subject",
              "ref_fields": [
                "organization_id"]}}}}}}}
```


Result for `zeus find_by organizations _id 119` should include the references in the next format:

```ruby
{
  "_id": 119,
  "url": "http://initech.zendesk.com/api/v2/organizations/119.json",
  ...
  "users_0": "Francisca Rasmussen",
  "users_1": "Pitts Park",
  "users_2": "Moran Daniels",
  "users_3": "Catalina Simpson",
  "tickets_0": "A Nuisance in Bangladesh",
  "tickets_1": "A Catastrophe in San Marino",
  "tickets_2": "A Drama in Chad",
  "tickets_3": "A Problem in Guatemala",
  "tickets_4": "A Nuisance in Suriname",
  "tickets_5": "A Catastrophe in Thailand",
  "tickets_6": "A Drama in Nigeria"
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem into your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sanchojaf/zeus
