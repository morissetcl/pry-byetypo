# frozen_string_literal: true

module Setup
  module Checks
    class DatabasePool
      class << self
        def check(database_config)
          logger = Logger.new($stdout)

          begin
            URI.parse(database_config["pool"])
          rescue URI::InvalidURIError
            if ENV["DATABASE_POOL"].present?
              logger.info(infer_database_pool_msg)
              database_config["pool"] = ENV["DATABASE_POOL"]
            else
              logger.warn(missing_database_pool_msg)
            end
          end
        end

        private

        def missing_database_pool_msg
          "[PRY-CYRANO] ENV[\"DATABASE_POOL\"] is empty. Please add a value to it to make pry-cyrano work."
        end

        def infer_database_pool_msg
          "[PRY-CYRANO] Database pool not readable, try to connect using the ENV[\"DATABASE_POOL\"]"
        end
      end
    end
  end
end
