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

  def self.run(times)
    QuestionMapper.new.each_question.take(times).each do |q|
      Injector::Gateway.new.new_question(q)
    end
  end
end
