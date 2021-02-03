require 'csv'
require 'json'

module LiveMentorTechTest
  class JsonTranslator
    attr_reader :doc

    def initialize(doc)
      @doc = doc
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
