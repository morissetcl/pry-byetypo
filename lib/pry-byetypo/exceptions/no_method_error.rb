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
      eval(infer_klass).methods.map(&:to_s) # rubocop:disable Security/Eval
    end

    def exception_regexp
      /`([^']+)' for/
    end

    def klass
      exception_without_class_module = exception.to_s.gsub(":Class", "")
      exception_without_class_module.split.last
    end

    # [].methods and Array.methods have a different output.
    # Array class is a part of the Ruby core library while `[]` is an instance of the Array class.
    # When calling [].methods, we inspect the methods available to instances of the Array class, including those inherited from its class and ancestors.
    def infer_klass
      return klass if klass != "Array"

      "[]"
    end
  end
end
