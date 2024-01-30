# frozen_string_literal: true

require_relative "base"
require_relative "exceptions/active_record/statement_invalid"
require_relative "exceptions/active_record/configuration_error"
require_relative "exceptions/name_error/base"
require_relative "constants/errors"

class ExceptionsHandler < Base
  attr_reader :exception, :output, :pry

  def initialize(output, exception, pry)
    @output = output
    @exception = exception
    @pry = pry
  end

  def call
    case exception
    in NameError
      # NameError is a Superclass for all undefined statement.
      Exceptions::NameError::Base.call(output, exception, pry)
    in ActiveRecord::StatementInvalid
      # ActiveRecord::StatementInvalid is a Superclass for all database execution errors.
      # We only need to one including an `UndefinedTable` error.
      return pry_exception_handler unless exception.message.include?(Constants::Errors::UNDEFINED_TABLE)
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
