# frozen_string_literal: true

require_relative "../exceptions_base"

module Exceptions
  module ActiveRecord
    class Base < ExceptionsBase
      private

      def corrected_word
        @corrected_word ||= spell_checker(associations_dictionary).correct(unknown_from_exception).first
      end

      def corrected_cmd
        @corrected_cmd ||= last_cmd.gsub(/\b#{unknown_from_exception}\b/, corrected_word)
      end

      def unknown_from_exception
        exception.to_s.match(exception_regexp)[1]
      end

      def associations_dictionary
        @associations_dictionary ||= store.transaction { |s| s["associations"] }
      end
    end
  end
end