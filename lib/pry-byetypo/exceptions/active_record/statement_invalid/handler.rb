# frozen_string_literal: true

require_relative "../../exceptions_base"
require_relative "../../../constants/errors"
require_relative "undefined_table"
require_relative "undefined_column"

module Exceptions
  module ActiveRecord
    module StatementInvalid
      class Handler < ExceptionsBase
        attr_reader :exception, :output, :pry

        def initialize(output, exception, pry)
          @output = output
          @exception = exception
          @pry = pry
        end

        # FIXME: https://github.com/rubocop/rubocop-performance/issues/438
        # rubocop:disable Performance/ConstantRegexp
        def call
          case exception.message
          in /#{Constants::Errors::UNDEFINED_TABLE}/
            UndefinedTable.call(output, exception, pry)
          in /#{Constants::Errors::UNDEFINED_COLUMN}/
            UndefinedColumn.call(output, exception, pry)
          else
            Pry::ExceptionHandler.handle_exception(output, exception, pry)
          end
        end
        # rubocop:enable Performance/ConstantRegexp
      end
    end
  end
end
