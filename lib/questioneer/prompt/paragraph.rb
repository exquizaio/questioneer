module Questioneer::Prompt
  class Paragraph
    attr_accessor :content, :type
    def initialize(type: "paragraph", content:)
      @type, @content = type, content
    end
  end
end
