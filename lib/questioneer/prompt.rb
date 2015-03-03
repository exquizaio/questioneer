require_relative "prompt/paragraph"
require_relative "prompt/katex"
require_relative "prompt/passage"
module Questioneer
  module Prompt
    @@types = {"Paragraph" => Paragraph, "Katex" => Katex, "Passage" => Passage}
    def self.for(type)
      @@types[type]
    end
  end
end
