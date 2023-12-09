# frozen_string_literal: true

require_relative "exceptions_base"

module Exceptions
  class MissingFromClauseEntryTable < ExceptionsBase
    private

    def correct_error
      unknown_table_name = exception.to_s.match(/PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "(.*?)"\nLINE/)[1]
      corrected_word = spell_checker(dictionary).correct(unknown_table_name).first

      last_cmd = Pry.line_buffer.last.strip
      corrected_cmd = last_cmd.gsub(/\b#{unknown_table_name}\b/, corrected_word)

      logger.info("🤓 `#{unknown_table_name}` table relation not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓")
      logger.info("🤓  running #{corrected_cmd} 🤓")

      pry.eval(corrected_cmd)
    end
  end
end
