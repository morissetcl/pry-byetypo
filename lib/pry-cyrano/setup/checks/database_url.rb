# frozen_string_literal: true

module Setup
  module Checks
    class DatabaseUrl
      class << self
        def check(database_config, logger)
          begin
            URI.parse(database_config["url"])
          rescue URI::InvalidURIError
            if ENV["DATABASE_URL"].present?
              logger.info(infer_database_url_msg)
              database_config["url"] = ENV["DATABASE_URL"]
            else
              logger.warn(missing_database_url_msg)
            end
          end
        end

        private

        def missing_database_url_msg
          "[PRY-CYRANO] ENV[\"DATABASE_URL\"] is empty. Please add a value to it to make pry-cyrano work."
        end

        def infer_database_url_msg
          "[PRY-CYRANO] Database URL not readable, try to connect using the ENV[\"DATABASE_URL\"]"
        end
      end
    end
  end
end
