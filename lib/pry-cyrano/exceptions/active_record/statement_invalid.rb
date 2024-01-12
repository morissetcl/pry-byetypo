# frozen_string_literal: true

require_relative "base"

module Exceptions
  module ActiveRecord
    class StatementInvalid < Base
      private

      def infer_cmd
        logger.info("🤓 `#{unknown_from_exception}` table relation not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓")
        logger.info("🤓  running #{corrected_cmd} 🤓")

        pry.eval(corrected_cmd)
      end

      def exception_regexp
        /PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "(.*?)"\nLINE/
      end
    end
  end
end
