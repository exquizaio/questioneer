require "logger"
module Questioneer
  class Configuration
    attr_accessor :logger, :start_path, :end_path, :login

    def initialize(**options)
      @logger = options.fetch(:logger) { Logger.new($stdout) }
      @start_path = options.fetch(:start_path) { "http://rails-beanstalk-env-m2nmpfvpsr.elasticbeanstalk.com" }
      @end_path = options.fetch(:end_path) { "http://ec2-54-86-16-95.compute-1.amazonaws.com" }
      @login = options.fetch(:login) { {email: "spam@patrickmetcalfe.com", password: "77057705"} }
    end
  end
end
