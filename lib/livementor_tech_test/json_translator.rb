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
          @headers = @doc.map do |el|
            puts el.inspect()
          end
        elsif @doc.class == Hash
          @headers = @doc.keys.map do |el|
            puts el.inspect()
          end
        else
        end
      end

      @headers
    end

    private

    def parse_header(hash)
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
