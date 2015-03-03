module Questioneer::Prompt
  class Katex
    attr_accessor :content, :type
    def initialize(type: "katex", content:)
      @type, @content = type, content
    end
  end
end
