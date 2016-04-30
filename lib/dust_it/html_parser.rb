module DustIt
  class HTMLParser
    def initialize(raw_html, options = {})
      @raw_html = raw_html
    end

    def parse
      @html ||= Nokogiri::HTML(@raw_html)
    end
  end
end
