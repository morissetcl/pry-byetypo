# frozen_string_literal: true

require_relative "base"

class ExceptionHandler < Base
  attr_reader :exception, :output, :pry

  def initialize(output, exception, pry)
    @output = output
    @exception = exception
    @pry = pry
  end

  def call
    case @exception.to_s
    in /^uninitialized constant/
     #  UninitializedConstant.call
      handle_uninitialized_constant(@output, @exception, @pry)
    in /^PG::UndefinedTable: ERROR:  missing FROM-clause entry for table/
      # MissingFromClauseEntryTable.call
      missing_from_clause_entry_table(@output, @exception, @pry)
    in /^Can't join/
      # ActiveRecordConfigurationError.call
      active_record_configuration_error(@output, @exception, @pry)
    else
      Pry::ExceptionHandler.handle_exception(output, exception, pry)
    end
  end
end