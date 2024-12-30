# frozen_string_literal: true

require "uri"
require "byebug"
require 'logger'

class Base
  class << self
    def check
      URI.parse(Setup::Database.config[name])
    rescue URI::InvalidURIError
      # Try to connect using the ENV variables.
      if ENV[variable]
        p ENV[variable]
        URI.parse(ENV[variable])
      else
        logger = Logger.new(STDOUT)
        logger.warn(missing_variable_msg)
      end
    end
  end
end 
