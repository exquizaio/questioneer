require "mechanize"
module Injector
  class Gateway

    attr_accessor :agent

    def initialize(login = Questioneer.login)
      @login = login
      @agent = Mechanize.new
      sign_in!
    end

    def questions_index_url
      @@question_index_url ||= URI.join(Questioneer.end_path, "/questions")
    end

    def sign_in!
      form = @agent.get(Questioneer.end_path).form_with(action: "/users/sign_in")
      form["user[email]"] = @login[:email]
      form["user[password]"] = @login[:password]
      page = @agent.submit(form)
    end

    def new_question_page_for_type(type:, form: @questions_page.form_with(action: "/questions/new"))
      form.field_with(:name => "prompt_type").option_with(:value => type).click
      @agent.submit(form)
    end

    def new_question(question)
      @questions_page = @agent.get questions_index_url
      sign_in! @questions_page if @questions_page.uri.path.include? "sign_in"
      new_question_page = new_question_page_for_type type: question.prompt.type.downcase

      new_question_form = new_question_page.form_with(action: "/questions")

      new_question_form["question[difficulty]"] = question.difficulty
      new_question_form["question[grade_level]"] = question.grade_level
      new_question_form["question[subject_list]"] = question.subjects
      new_question_form["question[tag_list]"] = question.tags

      fill_in_prompt question.prompt, form: new_question_form
      fill_in_choices question.choices, form: new_question_form
      @agent.submit(new_question_form)
      puts "."
    end

    def fill_in_choices(choices, form:)
      choices.map.with_index do |c, i|
        form.checkbox_with(name: "question[choices_attributes][#{i}][answer]").check if c.answer?
        form["question[choices_attributes][#{i}][content]"] = c.content
      end
    end

    def fill_in_prompt(prompt, form:)
      if prompt.type == "passage"
        form["question[prompt_attributes][passage_attributes][title]"] = prompt.title
        form["question[prompt_attributes][passage_attributes][author]"] = prompt.author
        form["question[prompt_attributes][passage_attributes][source]"] = prompt.source
        form["question[prompt_attributes][passage_attributes][body]"] = prompt.body
      end
      form["question[prompt_attributes][content]"] = prompt.content
    end
  end
end
