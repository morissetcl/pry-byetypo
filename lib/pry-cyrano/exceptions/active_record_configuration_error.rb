# frozen_string_literal: true

require_relative "active_record_exceptions"

module Exceptions
  class ActiveRecordConfigurationError < ActiveRecordExceptions
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
