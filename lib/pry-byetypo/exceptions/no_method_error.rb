# frozen_string_literal: true

require_relative "exceptions_base"

module Exceptions
  class NoMethodError < ExceptionsBase
    private

    def corrected_cmd
      @corrected_cmd ||= last_cmd.gsub(/\b#{unknown_from_exception}\b/, corrected_word)
    end

    def unknown_from_exception
      exception.to_s.match(exception_regexp)[1]
    end

    def dictionary
      eval(klass).methods.map(&:to_s) # rubocop:disable Security/Eval
    end

    def exception_regexp
      /`([^']+)' for/
    end

    def klass
      exception.to_s.match(/for\s+(.*?):\w*$/)[1]
    end
  end
end
