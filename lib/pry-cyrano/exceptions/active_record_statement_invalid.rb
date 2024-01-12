# frozen_string_literal: true

require_relative "active_record_exceptions"

module Exceptions
  class ActiveRecordStatementInvalid < ActiveRecordExceptions
    private

    def correct_error
      logger.info("🤓 `#{unknown_from_exception}` table relation not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓")
      logger.info("🤓  running #{corrected_cmd} 🤓")

      pry.eval(corrected_cmd)
    end

    def exception_regexp
      /PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "(.*?)"\nLINE/
    end
  end
end
