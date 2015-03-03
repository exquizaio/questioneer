module Questioneer
  class QuestionMapper
    attr_reader :gateway

    def initialize(gateway = Questioneer.from_gateway)
      @gateway = gateway
    end

    def all
      each_question.to_a
    end

    def each_question
      return to_enum(__callee__) unless block_given?
      gateway.question_list.each do |q|
        prompt_type = q.delete(:prompt_type)
        edit_page = gateway.agent.get q.delete(:edit_url)
        question = Question.new(
        **q,
        prompt: PromptMapper.new(edit_page).call,
        choices: ChoiceMapper.new(edit_page).all)
        yield(question)
      end
    end
  end
end
