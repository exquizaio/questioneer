class Question
  attr_accessor :grade_level, :difficulty, :prompt, :choices, :subjects, :tags
  def initialize(grade_level:, difficulty:, subjects:, tags:, prompt:, choices:)
    @grade_level, @difficulty, @prompt, @choices, @subjects, @tags = grade_level, difficulty, prompt, choices, subjects, tags
  end
end
