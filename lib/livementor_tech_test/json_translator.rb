require 'csv'
require 'json'

module LiveMentorTechTest
  class JsonTranslator
    attr_reader :doc

    def initialize(doc)
      @doc = doc
      @it = 0
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

    def read_line
      if !block_given?
        if @doc.class == Array
          return dig_line(@doc[@it])
          @it += 1
        else
          return dig_line(@doc)
        end
      end

      if @doc.class == Array
        @doc.each do |el|
          yield dig_line(hash)
        end
      else
        yield dig_line(@doc)
      end
    end

    private

    def extract_headers_from_hash(hash)
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
        hash.dig(*nested_path)
      end
    end

    class << self
      def from_file(path)
        doc = JSON.load_file(path)
        if doc.class != Array and doc.class != Hash
          raise LiveMentorTechTest::Error
        end

        JsonTranslator.new(doc)
      end

      def from_str(str)
        doc = JSON.parse(str)
        if doc.class != Array and doc.class != Hash
          raise LiveMentorTechTest::Error
        end

        JsonTranslator.new(doc)
      end
    end
  end
end
