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
          "[PRY-BYETYPO] ENV[\"DATABASE_POOL\"] is empty. Please assign a value to it to enable the functionality of pry-byetypo."
        end
      end
    end
  end
end
