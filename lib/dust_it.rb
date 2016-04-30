require 'net/http'
require "nokogiri"
require "colorize"
require "dust_it/version"
require "dust_it/html_parser"
require "dust_it/pinger"
require "dust_it/generator"

module DustIt
  class << self
    def initialize
      @gen = Generator.new
    end

    def start
      initialize
      puts "Running DustIt v0.1 !".blue
      100000.times do
        flow
      end
    end

    private

    def flow
      url = @gen.url
      res = get(url)
      result = analyse(res)
      keep(result, url)
    end

    def get(url)
      Pinger.new(url)
    end

    def analyse(res)      
      return nil unless res.state        
      html = HTMLParser.new(res.body).parse
      return :nothing if html.title == "YouTube"
      html.css(".privacy-icon").present? ? :private : :public
    end

    def keep(result, url)
      @count ||= {nothing: 0, public: 0, private: 0}
      case result
      when :nothing
        @count[:nothing] += 1
      when :public
        @count[:public] += 1
        File.open("output/public.txt","a+") { |f| f.puts(url) }
      when :private
        @count[:private] += 1
        File.open("output/private.txt","a+") { |f| f.puts(url) }
      end
      show(@count)
    end

    def show(count)
      @ite ||= 0
      @ite += 1
      @mem_pri ||= 0
      @mem_pub ||= 0
      if @ite >= 1000
        total = @count[:nothing] + @count[:public] + @count[:private]
        puts "#{total} vidéos analysées..."
        @ite = 0
      end
      if @mem_pub != @count[:public]
        puts "Nouvelle vidéo publique !".yellow
        @mem_not = @count[:public]
      end
      if @mem_pri != @count[:private]
        puts "Nouvelle vidéo privée !".red
        @mem_not = @count[:private]
      end
    end
  end
end
