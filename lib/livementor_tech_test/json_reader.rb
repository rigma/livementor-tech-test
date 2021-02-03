require 'csv'
require 'json'

module LiveMentorTechTest
  class JsonReader
    attr_reader :doc

    def initialize(doc)
      @doc = doc
      @it = -1
    end

    def headers
      if @headers == nil
        if @doc.class == Array
          @headers = @doc.reduce([]) do |headers, el|
            if el.class == Hash
              headers.union(extract_headers_from_hash el)
            else
              # We are ignoring other object than hash sets for now
              headers
            end
          end
        elsif @doc.class == Hash
          @headers = extract_headers_from_hash @doc
        end
      end

      @headers
    end

    def read_lines
      if @doc.class == Array
        if block_given?
          @doc.each do |el|
            yield dig_line(el)
          end
        else
          @doc.map { |el| dig_line(el) }
        end
      else
        if block_given?
          yield dig_line(@doc)
        else
          dig_line(@doc)
        end
      end
    end

    def read_line
      if @doc.class == Array
        @it += 1
        return dig_line(@doc[@it])
      else
        return dig_line(@doc)
      end
    end

    def rewind
      @it = -1
    end

    def to_csv
      lines = read_lines.map do |line|
        CSV::Row.new(self.headers, line)
      end

      CSV::Table.new(lines)
    end

    private

    def extract_headers_from_hash(hash)
      if hash.class != Hash
        raise LiveMentorTechTest::Error
      end

      headers = hash.keys.map do |key|
        if hash[key].class == Hash
          sub_keys = extract_headers_from_hash(hash[key])
          sub_keys.map { |sub_key| "#{key}.#{sub_key}" }
        else
          key
        end
      end

      headers.flatten
    end

    def dig_line(hash)
      if hash.class != Hash
        raise LiveMentorTechTest::Error
      end

      self.headers.map do |header|
        nested_path = header.split(".")
        value = hash.dig(*nested_path)
        value = value.join(",") unless value.class != Array
        value
      end
    end

    class << self
      def from_file(path)
        doc = JSON.load_file(path)
        if doc.class != Array and doc.class != Hash
          raise LiveMentorTechTest::Error
        end

        JsonReader.new(doc)
      end

      def from_str(str)
        doc = JSON.parse(str)
        if doc.class != Array and doc.class != Hash
          raise LiveMentorTechTest::Error
        end

        JsonReader.new(doc)
      end
    end
  end
end
