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
          "[PRY-CYRANO] ENV[\"DATABASE_URL\"] is empty. Please assign a value to it to enable the functionality of pry-cyrano."
        end
      end
    end
  end
end
