# frozen_string_literal: true

require_relative "base"

module Setup
  module Checks
    class DatabasePool < Base
      class << self
        def name
          "pool"
        end

        def variable
          "DATABASE_POOL"
        end

        def missing_variable_msg
          "[PRY-CYRANO] ENV[\"DATABASE_POOL\"] is empty. Please add a value to it to make pry-cyrano work."
        end

        def infer_database_variable_msg
          "[PRY-CYRANO] Database #{name} not readable, try to connect using the ENV[\"DATABASE_POOL\"]"
        end
      end
    end
  end
end
