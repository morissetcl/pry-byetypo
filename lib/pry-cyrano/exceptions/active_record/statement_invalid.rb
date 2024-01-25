# frozen_string_literal: true

require_relative "base"

module Exceptions
  module ActiveRecord
    class StatementInvalid < Base
      private

      def exception_regexp
        /PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "(.*?)"\nLINE/
      end
    end
  end
end
