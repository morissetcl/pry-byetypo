# frozen_string_literal: true

require_relative "base"

module Exceptions
  module ActiveRecord
    class ConfigurationError < Base
      private

      def exception_regexp
        /association named '(.*?)'/
      end
    end
  end
end
