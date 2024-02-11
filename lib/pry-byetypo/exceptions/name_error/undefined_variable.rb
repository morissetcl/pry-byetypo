# frozen_string_literal: true

require_relative "../exceptions_base"

module Exceptions
  module NameError
    class UndefinedVariable < ExceptionsBase
      private

      def corrected_cmd
        @corrected_cmd ||= last_cmd.gsub(/\b#{unknown_from_exception}\b/, corrected_word)
      end

      def unknown_from_exception
        exception.to_s.match(exception_regexp)[1]
      end

      def dictionary
        store.transaction { |s| s[pry_instance_uid] }
      end

      def exception_regexp
        /`(\w+)'/
      end

      # Use the current binding identifier as pry instance uid.
      def pry_instance_uid
        pry.current_binding.to_s
      end
    end
  end
end
