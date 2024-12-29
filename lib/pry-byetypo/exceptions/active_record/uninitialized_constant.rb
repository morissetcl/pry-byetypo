# frozen_string_literal: true

require_relative "base"

module Exceptions
  module ActiveRecord
    class UninitializedConstant < Base
      private

      def unknown_from_exception
        # Returns the first word after Unitialized constant error message.
        exception.to_s.split[2]
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
