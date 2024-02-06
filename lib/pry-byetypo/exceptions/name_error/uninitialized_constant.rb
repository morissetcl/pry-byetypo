# frozen_string_literal: true

require_relative "../exceptions_base"

module Exceptions
  module NameError
    class UninitializedConstant < ExceptionsBase
      private

      def unknown_from_exception
        exception.to_s.split.last
      end

      def corrected_cmd
        @corrected_cmd ||= last_cmd.gsub(unknown_from_exception, corrected_word)
      end

      def dictionary
        @ar_models_dictionary ||= store.transaction { |s| s["active_record_models"] }
      end
    end
  end
end
