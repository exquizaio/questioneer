module Questioneer
  class Choice
    attr_accessor :content, :type, :answer
    def initialize(content:, answer:)
      @type = content.start_with?("#Katex#") ? :katex : :default
      @content, @answer = content, answer
    end

    def katex?
      @type === :katex
    end

    def answer?
      !!answer
    end
  end
end
