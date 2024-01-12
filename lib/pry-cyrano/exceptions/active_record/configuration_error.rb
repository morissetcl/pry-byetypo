# frozen_string_literal: true

require_relative "base"

module Exceptions
  module ActiveRecord
    class ConfigurationError < Base
      private

      def correct_error
        logger.info("🤓 `#{unknown_from_exception}` association not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓")
        logger.info("🤓  running #{corrected_cmd} 🤓")

        pry.eval(corrected_cmd)
      end

      def exception_regexp
        /association named '(.*?)'/
      end
    end
  end
end
