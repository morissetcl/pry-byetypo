# frozen_string_literal: true

require_relative "exceptions_base"

module Exceptions
  class MissingFromClauseEntryTable < ExceptionsBase
    def call
      missing_from_clause_entry_table
    end

    private

    def missing_from_clause_entry_table
      unknown_table_name = exception.to_s.match(/PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "(.*?)"\nLINE/)[1]
      corrected_word = spell_checker(dictionary).correct(unknown_table_name).first

      last_cmd = Pry.line_buffer.last.strip
      correct_cmd = last_cmd.gsub(/\b#{unknown_table_name}\b/, corrected_word)

      output.puts "🤓 `#{unknown_table_name}` table relation not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓"
      output.puts "🤓  running #{correct_cmd} 🤓"

      pry.eval(correct_cmd)
    end
  end
end
