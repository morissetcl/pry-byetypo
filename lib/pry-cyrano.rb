# frozen_string_literal: true

require 'pry'

require 'zeitwerk'
require 'byebug'

require_relative 'pry-cyrano/version'
require_relative 'pry-cyrano/application_dictionary'

module Pry::Cyrano
  Pry.config.hooks.add_hook(:before_session, :eager_loading) do |output, exception, _pry_|
    dictionary_instance = ApplicationDictionary.new
    @ar_models_dictionary = dictionary_instance.active_record_models
    @associations_dictionary = dictionary_instance.associations
  end

  @attempts = 0
  MAX_ATTEMTPS = 3

  # TODO: If max attempt reached clean the last entries (eg: max entry 3 has been reached, we remove the last 3 history entries)
  Pry.config.exception_handler = proc do |output, exception, _pry_|
    @attempts += 1

    if @attempts < MAX_ATTEMTPS
      handle_uninitialized_constant(output, exception, _pry_) if exception.to_s.start_with?("uninitialized constant")
      missing_from_clause_entry_table(output, exception, _pry_) if exception.to_s.start_with?("PG::UndefinedTable: ERROR:  missing FROM-clause entry for table")
      active_record_configuration_error(output, exception, _pry_) if exception.to_s.start_with?("Can't join")
    end
    reset_attempts

    Pry::ExceptionHandler.handle_exception(output, exception, _pry_) unless handled_exception?(exception)
  end

  class << self
    def handled_exception?(exception)
      return false if max_attempts_reached?

      exception.to_s.start_with?("uninitialized constant") ||
        exception.to_s.start_with?("PG::UndefinedTable: ERROR:  missing FROM-clause entry for table") ||
          exception.to_s.start_with?("Can't join")
    end

    def spell_checker(dictionary)
      DidYouMean::SpellChecker.new(dictionary: dictionary)
    end

    def reset_attempts
      @attempts = 0
    end

    def max_attempts_reached?
      @attempts > MAX_ATTEMTPS
    end

    def handle_uninitialized_constant(output, exception, _pry_)
      mispelled_word = exception.to_s.split.last
      corrected_word = spell_checker(@ar_models_dictionary).correct(mispelled_word).first

      last_cmd = Pry.line_buffer.last.strip
      correct_cmd = last_cmd.gsub(mispelled_word, corrected_word)

      output.puts "🤓 #{mispelled_word} does not exist, running the command with #{corrected_word} assuming is what you meant. 🤓"
      output.puts "🤓  running #{correct_cmd} 🤓"

      _pry_.eval(correct_cmd)
    end

    def missing_from_clause_entry_table(output, exception, _pry_)
      unknown_table_name = exception.to_s.match(/PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "(.*?)"\nLINE/)[1]
      corrected_word = spell_checker(@associations_dictionary).correct(unknown_table_name).first

      last_cmd = Pry.line_buffer.last.strip
      correct_cmd = last_cmd.gsub(/\b#{unknown_table_name}\b/, corrected_word)

      output.puts "🤓 `#{unknown_table_name}` table relation not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓"
      output.puts "🤓  running #{correct_cmd} 🤓"

      _pry_.eval(correct_cmd)
    end

    def active_record_configuration_error(output, exception, _pry_)
      unknown_association = exception.to_s.match(/association named '(.*?)'/)[1]
      corrected_word = spell_checker(@associations_dictionary).correct(unknown_association).first

      last_cmd = Pry.line_buffer.last.strip
      correct_cmd = last_cmd.gsub(/\b#{unknown_association}\b/, corrected_word)

      output.puts "🤓 `#{unknown_association}` association not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓"
      output.puts "🤓  running #{correct_cmd} 🤓"

      _pry_.eval(correct_cmd)
    end
  end
end