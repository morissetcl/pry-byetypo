# frozen_string_literal: true

require_relative "exceptions_base"

module Exceptions
  class NameError < ExceptionsBase
    private

    def correct_error
      mispelled_word = exception.to_s.split.last
      corrected_word = spell_checker(ar_models_dictionary).correct(mispelled_word).first

      last_cmd = Pry.line_buffer.last.strip
      corrected_cmd = last_cmd.gsub(mispelled_word, corrected_word)

      logger.info("🤓 #{mispelled_word} does not exist, running the command with #{corrected_word} assuming is what you meant. 🤓")
      logger.info("🤓  running #{corrected_cmd} 🤓")

      pry.eval(corrected_cmd)
    end
  end
end
