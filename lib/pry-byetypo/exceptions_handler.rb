# frozen_string_literal: true

require_relative "base"
require_relative "exceptions/active_record/statement_invalid"
require_relative "exceptions/active_record/configuration_error"
require_relative "exceptions/name_error/uninitialized_constant"
require_relative "exceptions/name_error/undefined_variable"

class ExceptionsHandler < Base
  attr_reader :exception, :output, :pry

  UNINITIALIZED_CONSTANT = "uninitialized constant"
  UNDEFINED_VARIABLE = "undefined local variable"
  UNDEFINED_TABLE = "UndefinedTable"

  def initialize(output, exception, pry)
    @output = output
    @exception = exception
    @pry = pry
  end

  def call
    case exception
    in NameError => error
      # NameError is a Superclass for all undefined statement.
      if error.message.include?(UNINITIALIZED_CONSTANT)
        # In this context we only need to one including an `undefined local variable` error.
        Exceptions::NameError::UninitializedConstant.call(output, exception, pry)
      elsif error.message.include?(UNDEFINED_VARIABLE)
        # In this context we only need to one including an `uninitialized constant` error.
        Exceptions::NameError::UndefinedVariable.call(output, exception, pry)
      else
        pry_exception_handler
      end
    in ActiveRecord::StatementInvalid => error
      # ActiveRecord::StatementInvalid is a Superclass for all database execution errors.
      # We only need to one including an `UndefinedTable` error.
      return pry_exception_handler unless error.message.include?(UNDEFINED_TABLE)
      Exceptions::ActiveRecord::StatementInvalid.call(output, exception, pry)
    in ActiveRecord::ConfigurationError
      Exceptions::ActiveRecord::ConfigurationError.call(output, exception, pry)
    else
      pry_exception_handler
    end
  end

  private

  def pry_exception_handler
    Pry::ExceptionHandler.handle_exception(output, exception, pry)
  end
end
