module Questioneer::Prompt
  class Passage
    attr_accessor :title, :author, :source, :body, :content, :type
    def initialize(type: "passage", title:, author:, source:, body:, content:)
      @type, @title, @author, @source, @body, @content = type, title, author, source, body, content
    end
  end
end
