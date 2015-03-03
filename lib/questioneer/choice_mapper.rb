module Questioneer
  class ChoiceMapper
    attr_reader :page
    def initialize(page)
      @page = page
      @choices = @page.parser.at_css("ol")
    end

    def all
      each_choice.to_a
    end

    def each_choice
      return to_enum(__callee__) unless block_given?
      @choices.search("li").map do |c|
        choice = Choice.new(
        answer: !c.at_css("[checked='checked']").nil?,
        content: c.at_css("[placeholder='New Choice Text']").text.strip )
        yield(choice)
      end
    end
  end
end
