require 'csv'
require 'json'

module LiveMentorTechTest
  ##
  # This class provides a JSON document reader which will read a submitted JSON object or
  # array into a CSV readable lines. It also extracts the CSV header line from the objects
  # contained in the JSON document.
  #
  # = Warning
  # This class will raise an error if you ask it to read a JSON array not only composed of
  # JSON object!

  class JsonReader
    ##
    # A read-only access to the parsed JSON document used by the reader.

    attr_reader :doc

    ##
    # Instanciates a new JSON reader which will read +doc+.
    #
    # +doc+ must be a valid Ruby array or a JsonReaderError will be raised.

    def initialize(doc)
      # We ignore other objects than Array and Hash and we raise an error in this case
      if doc.class != Array
        raise JsonReaderError, "A JSON array must be provided to the JSON reader"
      end

      doc.each do |el|
        if el.class != Hash
          raise JsonReaderError, "The provided JSON array must only contains JSON objects"
        end
      end

      @doc = doc
      @it = -1
    end

    ##
    # Returns the headers extracted from the JSON document used by the current reader.
    #
    # This attribute is lazy-loaded: it has to be called once to extract CSV headers from
    # the internal JSON document and the result of the extraction will be memory-cached.

    def headers
      if @headers == nil
        @headers = @doc.reduce([]) do |headers, el|
          if el.class == Hash
            headers.union extract_headers_from_hash(el)
          else
            # We are ignoring other object than hash sets for now
            # We'll raise an error if we find something else
            raise JsonReaderError, "Your JSON array is not only composed of JSON objects"
          end
        end
      end

      @headers
    end

    ##
    # Returns a line from the JSON document read. If the document is an array and that we
    # have reached the end of the document, a JsonReaderError will be raised.
    #
    # = Parameters
    #
    # +into_csv_row+:: Returns read line in a CSV::Row object instead of an Array.

    def read_line(into_csv_row = false)
      if @it >= @doc.size
        raise JsonReaderError, "JSON document end is already reached"
      end

      @it += 1
      dig_line(@doc[@it], into_csv_row)
    end

    ##
    # Read all the lines contained into the JSON document. All lines will be returned
    # into an array.
    #
    # = Parameters
    #
    # +into_csv_row+:: Returns read lines in a CSV::Row object instead of an Array.

    def read_lines(into_csv_row = false)
      @doc.map { |el| dig_line(el, into_csv_row) }
    end

    ##
    # Rewinds the cursor of the current reader to the beginning of the document.

    def rewind
      @it = -1
    end

    ##
    # Exports the JSON document read into a CSV::Table object.

    def to_csv
      CSV::Table.new read_lines(true)
    end

    class << self
      ##
      # Instanciates a new JsonReader which will read a JSON file located at +path+ on your
      # file system.
      #
      # = Parameters
      #
      # +path+:: The path to the JSON file to read.

      def from_file(path)
        doc = JSON.load_file(path)
        if doc.class != Array
          raise JsonReaderError, "Parsed JSON document is not a JSON object, nor a JSON array"
        end

        JsonReader.new(doc)
      end

      ##
      # Instanciates a new JsonReader which will read a JSON document stored into a string
      # representation.
      #
      # = Parameters
      #
      # +str+:: The string representation of the JSON document to read.

      def from_str(str)
        doc = JSON.parse(str)
        if doc.class != Array
          raise JsonReaderError, "Parsed JSON document is not a JSON object, nor a JSON array"
        end

        JsonReader.new(doc)
      end
    end

    private

    ##
    # Extracts the headers from a JSON object represented by a Ruby Hash.
    #
    # = Parameters
    #
    # +hash+:: The Ruby hash which will be used to extract headers.

    def extract_headers_from_hash(hash)
      # Raising an error if the provided parameter is not a Hash
      if hash.class != Hash
        raise JsonReaderError, "Provided parameter is not a Ruby Hash"
      end

      # We'll extract the keys of a hash in a new array we'll return
      headers = hash.keys.map do |key|
        # If the current extracted key is mapping a hash, we'll start a new recursion of
        # the current method
        if hash[key].class == Hash
          sub_keys = extract_headers_from_hash(hash[key])

          # Once the sub keys have been extracted, we'll concatenate the current key of all
          # subkeys
          sub_keys.map { |sub_key| "#{key}.#{sub_key}" }
        else
          key
        end
      end

      # Once the recursion is completed, the output array may not be flat. Hence it can not be
      # used after. We'll flatten it to prevent such issue.
      headers.flatten
    end

    ##
    # Digs a CSV readable line from a JSON object represented into a Ruby hash.
    #
    # = Parameters
    #
    # +hash+:: The Ruby hash which will be used to dig the line.
    # +into_csv_row+:: Returns the digged line in a CSV::Row object instead of an Array.

    def dig_line(hash, into_csv_row = false)
      if hash.class != Hash
        raise JsonReaderError, "Provided parameter is not a Ruby Hash"
      end

      # We'll use the parsed headers from the JSON document to extract values
      line = self.headers.map do |header|
        # Forming the nested path that we'll be used to acces to the value
        nested_path = header.split(".")

        # Digging the value from the hash thanks to the nested path
        value = hash.dig(*nested_path)

        # If the value is an array, we'll join it using the ',' character as the joint
        value = value.join(",") unless value.class != Array

        value
      end

      if into_csv_row
        CSV::Row.new(self.headers, line)
      else
        line
      end
    end
  end

  ##
  # This class provides an error which can be raised by a JsonReader object.

  class JsonReaderError < StandardError; end
end
