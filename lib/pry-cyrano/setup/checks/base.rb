# frozen_string_literal: true

require "uri"

class Base
  class << self
    def check(database_config, logger)
      URI.parse(database_config[name])
    rescue URI::InvalidURIError
      if ENV[variable]
        logger.info(infer_database_variable_msg)
        database_config[name] = ENV[variable]
      else
        logger.warn(missing_variable_msg)
      end
    end
  end
end
