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
        @doc.values
      end

      @headers
    end

    class << self
      def from_file(path)
        JsonTranslator.new(JSON.load_file(path))
      end

      def from_str(str)
        JsonTranslator.new(JSON.parse(str))
      end
    end
  end
end
