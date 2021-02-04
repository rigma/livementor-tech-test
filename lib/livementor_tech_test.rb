require "livementor_tech_test/json_reader"
require "livementor_tech_test/version"

##
# A Ruby module made for a technical interview at {LiveMentor}[https://www.livementor.com/] which
# contains a class to read JSON document as CSV document and convenient methods to transform JSON
# representations or files in CSV representations or files.

module LiveMentorTechTest
  ##
  # A convenient method to transform a JSON document into a CSV representation.
  # This method internally use LiveMentorTechTest::JsonReader to perform the
  # transformation
  #
  # If the provided parameter +json+ is not a String, a LiveMentorTechTest::Error will
  # be raised. Otherwise, if the JSON document is not valid, a LiveMentorTechTest::JsonReaderError
  # will be raised.
  #
  # = Parameters
  #
  # +json+:: The JSON document to converts into a CSV representation.

  def self.json2csv(json)
    if json.class != String
      raise Error, "Supplied argument is not a string"
    end

    reader = JsonReader.from_str json
    reader.to_csv.to_s
  end

  ##
  # A convenient method to transform a JSON file into a CSV file.
  # This method internally use LiveMentorTechTest::JsonReader to perform the transformation.
  #
  # The result of the transformation is stored in a new file located at +output_path+.
  #
  # If the +input_path+ does not exists on the disk, a LiveMentorTechTest::Error will be
  # raised. Otherwise, if the JSON document is not valid, a LiveMentorTechTest::JsonReaderError
  # will be raised
  #
  # = Parameters
  #
  # +input_path+:: The path to the JSON file used as input of the method.
  # +output_path+:: The path to the resulting CSV file.

  def self.fjson2csv(input_path, output_path)
    if !File.exist?(input_path)
      raise Error, "The JSON file #{input_path} does not exists"
    end

    reader = JsonReader.from_file input_path
    csv = reader.to_csv.to_s

    File.write(output_path, csv)
  end

  ##
  # This class provides the default error raised in the module.
  class Error < StandardError; end
end
