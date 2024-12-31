# frozen_string_literal: true

require_relative "../exceptions_base"

module Exceptions
  module ActiveRecord
    class Base < ExceptionsBase
      private

      def corrected_cmd
        @corrected_cmd ||= last_cmd.gsub(/\b#{unknown_from_exception}\b/, corrected_word.to_s)
      end

      def unknown_from_exception
        exception.to_s.match(exception_regexp)[1]
      end

      def dictionary
        store.transaction { |s| s["associations"] }
      end
    end
  end
end
