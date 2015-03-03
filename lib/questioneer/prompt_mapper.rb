module Questioneer
  class PromptMapper
    attr_reader :gateway, :question_id
    def initialize(page)
      @page = page
    end

    def call
      Prompt.for(type).new(**get_attributes)
    end

    private
    def type
      @type ||= @page.parser.at_css("[name='question[prompt_attributes][type_name]']")["value"].strip
    end

    def get_attributes
      {}.tap do |h|
        if type == "Passage"
          h[:title] = get_attribute("title", namespace: "passage")["value"].strip
          h[:author] = get_attribute("author", namespace: "passage")["value"].strip
          h[:source] = get_attribute("source", namespace: "passage")["value"].strip
          h[:body] = get_attribute("body", namespace: "passage").content.strip
        end
        h[:content] = get_attribute("content").content.strip
      end
    end

    def get_attribute(attribute, namespace: "")
      namespace += "_attributes_" unless namespace.empty?
      @page.parser.at_css("#question_prompt_attributes_#{namespace + attribute}")
    end
  end
end
