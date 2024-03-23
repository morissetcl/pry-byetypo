# frozen_string_literal: true

require_relative "../base"

module Exceptions
  module ActiveRecord
    module StatementInvalid
      class UndefinedColumn < Base
        private

        def can_correct?
          true
        end

        # The not found column name
        def exception_regexp
          /column \w+\.(\w+)\s/
        end

        def unknown_from_exception
          exception.to_s.match(exception_regexp)[1]
        end

        def corrected_word
          exception.to_s.match(hint_regexp)[1].split(".").last
        end

        # The table of the column
        def hint_regexp
          /"(\w+\.\w+)"/
        end
      end
    end
  end
end
