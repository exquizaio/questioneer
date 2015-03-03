require "forwardable"
require "questioneer/version"
require "questioneer/choice"
require "questioneer/prompt"
require "questioneer/question"
require "questioneer/choice_mapper"
require "questioneer/prompt_mapper"
require "questioneer/question_mapper"
require "questioneer/configuration"
require "questioneer/extractor/gateway"
require "questioneer/injector/gateway"
require "ruby-progressbar"
module Questioneer
  extend SingleForwardable
  def_delegators :configuration, :logger, :start_path, :end_path, :login

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @@configuration ||= Configuration.new
  end

  def self.reset
    @@configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.from_gateway
    @@from_gateway = Extractor::Gateway.new
  end

  def self.to_gateway
    #@@from_gateway = Injector::Gateway.new
  end

  def self.run()
    $progressbar = ProgressBar.create(:title => "Questions", :starting_at => 0, :total => 144)
    QuestionMapper.new.each_question do |q|
      $progressbar.progress += 0.5
      Injector::Gateway.new.new_question(q)
      $progressbar.progress += 0.5
    end
  end
end
