module DustIt
  class Pinger
    attr_reader :response

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
      @response = Net::HTTP.get_response(@uri)
    end  
  end
end
