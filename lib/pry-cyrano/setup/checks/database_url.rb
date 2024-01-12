# frozen_string_literal: true

require_relative "base"

module Setup
  module Checks
    class DatabaseUrl < Base
      class << self
        def name
          "url"
        end

        def variable
          "DATABASE_URL"
        end

        def missing_variable_msg
          "[PRY-CYRANO] ENV[\"DATABASE_URL\"] is empty. Please add a value to it to make pry-cyrano work."
        end

        def infer_database_variable_msg
          "[PRY-CYRANO] Database #{name.upcase} not readable, try to connect using the ENV[\"DATABASE_URL\"]"
        end
      end
    end
  end
end
