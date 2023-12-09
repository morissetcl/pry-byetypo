# frozen_string_literal: true

require_relative "base"

class ExceptionHandler < Base
  attr_reader :exception, :output, :pry, :ar_models_dictionary, :associations_dictionary

  def initialize(output, exception, pry, application_dictionary)
    @output = output
    @exception = exception
    @pry = pry
    @ar_models_dictionary = application_dictionary[:ar_models_dictionary]
    @associations_dictionary = application_dictionary[:associations_dictionary]
  end

  def call
    case @exception.to_s
    in /^uninitialized constant/
      # Exceptions::UninitializedConstant.call
      handle_uninitialized_constant(output, exception, pry)
    in /^PG::UndefinedTable: ERROR:  missing FROM-clause entry for table/
      # Exceptions::MissingFromClauseEntryTable.call
      missing_from_clause_entry_table(output, exception, pry)
    in /^Can't join/
      # Exceptions::ActiveRecordConfigurationError.call
      active_record_configuration_error(output, exception, pry)
    else
      Pry::ExceptionHandler.handle_exception(output, exception, pry)
    end
  end

  private

  def spell_checker(dictionary)
    DidYouMean::SpellChecker.new(dictionary: dictionary)
  end

  def handle_uninitialized_constant(output, exception, pry)
    mispelled_word = exception.to_s.split.last
    corrected_word = spell_checker(ar_models_dictionary).correct(mispelled_word).first

    last_cmd = Pry.line_buffer.last.strip
    correct_cmd = last_cmd.gsub(mispelled_word, corrected_word)

    output.puts "🤓 #{mispelled_word} does not exist, running the command with #{corrected_word} assuming is what you meant. 🤓"
    output.puts "🤓  running #{correct_cmd} 🤓"

    pry.eval(correct_cmd)
  end

  def missing_from_clause_entry_table(output, exception, pry)
    unknown_table_name = exception.to_s.match(/PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "(.*?)"\nLINE/)[1]
    corrected_word = spell_checker(associations_dictionary).correct(unknown_table_name).first

    last_cmd = Pry.line_buffer.last.strip
    correct_cmd = last_cmd.gsub(/\b#{unknown_table_name}\b/, corrected_word)

    output.puts "🤓 `#{unknown_table_name}` table relation not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓"
    output.puts "🤓  running #{correct_cmd} 🤓"

    pry.eval(correct_cmd)
  end

  def active_record_configuration_error(output, exception, pry)
    unknown_association = exception.to_s.match(/association named '(.*?)'/)[1]
    corrected_word = spell_checker(associations_dictionary).correct(unknown_association).first

    last_cmd = Pry.line_buffer.last.strip
    correct_cmd = last_cmd.gsub(/\b#{unknown_association}\b/, corrected_word)

    output.puts "🤓 `#{unknown_association}` association not found, running the command with `#{corrected_word}` assuming is what you meant. 🤓"
    output.puts "🤓  running #{correct_cmd} 🤓"

    pry.eval(correct_cmd)
  end
end
