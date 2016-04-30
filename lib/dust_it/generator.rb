module DustIt
  class Generator
    attr_accessor :set

    def initialize(set = nil, base = "https://www.youtube.com/watch?v=")
      @set = set if set
      @set ||= [*("a".."z"), *("A".."Z"), "-", "_", *("0".."9")]
      @base = base
    end

    def yt_key
      key = ""
      11.times do
        key << @set.sample
      end
      key
    end

    def url
      @base + yt_key
    end
  end
end
