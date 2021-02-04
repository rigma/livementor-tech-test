# LiveMentor Technical Test

This is a Ruby module writen for a technical test during an interview
with [Live Mentor], a french company providing online coaching to independant
workers.

The goal of the test is to provide a small Ruby library which provides
methods to convert a JSON array of objects into a CSV representation.

For instance, the following JSON input:

```json
{
  "id": 0,
  "tags": ["lorem", "ipsum"],
  "identities": {
    "github": {
      "id": 10,
      "username": "mona"
    },
    "stackoverflow": {
      "id": 20,
      "username": "lisa"
    }
  }
}
```

Should be translated into the following CSV representation:

```csv
id,tags,identities.github.id,identities.github.username,identities.stackoverflow.id,identites.username
0,"lorem,ipsum",10,mona,20,lisa

```

## Usage

First, you'll need to have Ruby 3 installed on your computer.

To use the library, you'll have to clone this repository first on your local computer. To do so, you'll have to type those commands:

```sh
$ git clone https://github.com/rigma/livementor-tech-test.git
$ cd livementor-tech-test
$ rake install
```

Once you've done it, you can use the library in `irb` or in a Ruby file thanks to:

```ruby
require "livementor_tech_test"
```

And voilà! You can use this library.

### Usage of `JsonReader` class

This class provided by the library is the main protagonist of the
transformation from a JSON array into a CSV table. You have three
ways to instanciates an object of this class:

```ruby
# You can instanciates it with the default constructor and an array of hashes
reader = LiveMentorTechTest::JsonReader.new array_of_hashes

# Or, you can parse a string representation of a JSON array
reader = LiveMentorTechTest::JsonReader.from_str raw_json

# Finally, you can load a JSON file
reader = LiveMentorTechTest::JsonReader.from_file input_file_path
```

The reader will now use this _document_ to extract CSV headers and lines. You
can either do it programmatically by using `#read_line` method, to retrieve
one by one the lines, or `#read_lines` method, to retrieve all the lines.

Those lines will follow the CSV headers extracted by the `#headers` method
of the `JsonReader` object.

You can also directly export the reader into a `CSV::Table` object by using
the `#to_csv` method.

### Convenient methods

This library also provides two convenient methods, which are using `JsonReader`
under the hood, to transform JSON strings and files into CSV format.

```ruby
# To transform a JSON string into a CSV string
csv = LiveMentorTechTest::json2csv '[{"a":1,"b":{"c":["hello","world"],"d":1.618}}]'

# To transform a JSON file into a CSV file
LiveMentorTechTest::fjson2csv input_path, output_path
```

## Running unit tests

This library comes with unit tests made with [RSpec]. To run it, you just
have to type this command in your terminal:

```sh
$ rake spec
# This is an alias
$ rake test
# It is also the default task
$ rake
```

## Generating RDoc

This library is also documented thanks to [RDoc]. To generate the local
documentation, you just have to type the following command in your terminal:

```sh
$ rake doc
```

## Copyrights

This code is unlicensed and can be used however you want it. See [UNLICENSE](./UNLICENSE) for further details.

[Live Mentor]: https://www.livementor.com
[RDoc]: https://github.com/ruby/rdoc
[RSpec]: https://rspec.info/
