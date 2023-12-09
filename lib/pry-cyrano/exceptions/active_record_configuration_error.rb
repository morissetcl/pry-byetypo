# frozen_string_literal: true

require_relative "exceptions_base"

module Exceptions
  class ActiveRecordConfigurationError < ExceptionsBase
    private

    def correct_error
      unknown_association = exception.to_s.match(/association named '(.*?)'/)[1]
      corrected_word = spell_checker(dictionary).correct(unknown_association).first

      last_cmd = Pry.line_buffer.last.strip
      corrected_cmd = last_cmd.gsub(/\b#{unknown_association}\b/, corrected_word)

      logger.info("🤓 `#{unknown_association}` association not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓")
      logger.info("🤓  running #{corrected_cmd} 🤓")

      pry.eval(corrected_cmd)
    end
  end
end
