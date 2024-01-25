# frozen_string_literal: true

require_relative "base"
require_relative "exceptions/active_record/statement_invalid"
require_relative "exceptions/active_record/configuration_error"
require_relative "exceptions/name_error"

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
      # eg: Usert.last
      Exceptions::NameError.call(output, exception, pry)
    in ActiveRecord::StatementInvalid => error
      # ActiveRecord::StatementInvalid is a Superclass for all database execution errors.
      # We only need to one including an `UndefinedTable` error.
      # eg: User.joins(:groups).where(grous: { name: "Landlord" }).last
      return unless error.message.include?("UndefinedTable")
      Exceptions::ActiveRecord::StatementInvalid.call(output, exception, pry)
    in ActiveRecord::ConfigurationError
      # eg:  User.joins(:group).where(groups: { name: "Landlord" }).last
      Exceptions::ActiveRecord::ConfigurationError.call(output, exception, pry)
    else
      Pry::ExceptionHandler.handle_exception(output, exception, pry)
    end
  end
end
