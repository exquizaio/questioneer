require "mechanize"
module Extractor
  class Gateway

    attr_accessor :agent

    def initialize(login = Questioneer.login)
      @login = login
      @agent = Mechanize.new
      sign_in!
    end

    def questions_index_url
      @@question_index_url ||= URI.join(Questioneer.start_path, "/questions")
    end

    def sign_in!
      form = @agent.get(Questioneer.start_path).form_with(action: "/users/sign_in")
      form["user[email]"] = @login[:email]
      form["user[password]"] = @login[:password]
      page = @agent.submit(form)
    end

    def question_list
      questions_page = @agent.get questions_index_url
      sign_in! questions_page if questions_page.uri.path.include? "sign_in"
      question_table = questions_page.search('table').detect { |t|
        headings = t.search('th').map(&:text)
        headings.include? "Difficulty"
      }

      question_rows  = question_table.search('tbody tr')
      max = question_rows.count
      question_rows.map.with_index { |row, index|
        columns      = row.search('td')
        id, prompt_type, prompt_short, difficulty, grade_level, subjects, tags, *actions = *columns
        edit_path    = actions[1].at("a")['href']
        edit_url     = URI.join(Questioneer.start_path, edit_path)
        {
          id: id.text.to_i,
          prompt_type: prompt_type.text.strip,
          difficulty: difficulty.text.strip.to_i,
          grade_level: grade_level.text.strip.to_i,
          subjects: subjects.text.strip,
          tags: tags.text.strip,
          edit_url:     edit_url.to_s
        }
      }
    end
  end
end
