# frozen_string_literal: true

require_relative "exceptions_base"

module Exceptions
  class UninitializedConstant < ExceptionsBase
    def call
      handle_uninitialized_constant
    end

    private

    def handle_uninitialized_constant
      mispelled_word = exception.to_s.split.last
      corrected_word = spell_checker(dictionary).correct(mispelled_word).first

      last_cmd = Pry.line_buffer.last.strip
      correct_cmd = last_cmd.gsub(mispelled_word, corrected_word)

      output.puts "🤓 #{mispelled_word} does not exist, running the command with #{corrected_word} assuming is what you meant. 🤓"
      output.puts "🤓  running #{correct_cmd} 🤓"

      pry.eval(correct_cmd)
    end
  end
end
