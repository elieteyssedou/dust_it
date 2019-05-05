module DustIt
  class Pinger
    attr_reader :response, :uri

    def initialize(url)
      @uri = URI(url)
      ping
    end

    def state
      @response.is_a?(Net::HTTPSuccess)
    end

    def body
      @response.body
    end

    private

    def ping
      begin
        @response = Net::HTTP.get_response(@uri.is_a?(URI) ? @uri : URI.parse(@uri))
        @uri = @response['location']
      end while @response.is_a?(Net::HTTPRedirection)

      @response
    end
  end
end
