# frozen_string_literal: true

require_relative "../exceptions_base"
require_relative "./uninitialized_constant"
require_relative "./undefined_variable"
require_relative "../../constants/errors"

module Exceptions
  module NameError
    class Base < ExceptionsBase

      attr_reader :exception, :output, :pry

      def initialize(output, exception, pry)
        @output = output
        @exception = exception
        @pry = pry
      end

      def call
        if exception.message.include?(Constants::Errors::UNINITIALIZED_CONSTANT)
          # In this context we only need to one including an `undefined local variable` error.
          UninitializedConstant.call(output, exception, pry)
        elsif exception.message.include?(Constants::Errors::UNDEFINED_VARIABLE)
          # In this context we only need to one including an `uninitialized constant` error.
          UndefinedVariable.call(output, exception, pry)
        else
          Pry::ExceptionHandler.handle_exception(output, exception, pry)
        end
      end
    end
  end
end
