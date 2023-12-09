# frozen_string_literal: true

require_relative "exceptions_base"

module Exceptions
  class ActiveRecordConfigurationError < ExceptionsBase
    def call
      active_record_configuration_error
    end

    private

    def active_record_configuration_error
      unknown_association = exception.to_s.match(/association named '(.*?)'/)[1]
      corrected_word = spell_checker(dictionary).correct(unknown_association).first

      last_cmd = Pry.line_buffer.last.strip
      correct_cmd = last_cmd.gsub(/\b#{unknown_association}\b/, corrected_word)

      output.puts "🤓 `#{unknown_association}` association not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓"
      output.puts "🤓  running #{correct_cmd} 🤓"

      pry.eval(correct_cmd)
    end
  end
end
