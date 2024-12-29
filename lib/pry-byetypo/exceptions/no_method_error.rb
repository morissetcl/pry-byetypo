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
      klass_methods = eval(infer_klass).methods # rubocop:disable Security/Eval
      # Early return because built_in class does not have access to `instance_methods`.
      return klass_methods.map(&:to_s) if built_in_klass

      instance_methods = eval(infer_klass).instance_methods(false) # rubocop:disable Security/Eval
      instance_methods.push(klass_methods).flatten.map(&:to_s)
    end

    def exception_regexp
      /`([^']+)' for/
    end

    def klass
      @klass ||= begin
        exception_without_class_module = exception.to_s.match(/for #<(\w+)/)
        exception_without_class_module[1]
      end
    end

    # [].methods and Array.methods have a different output.
    # Array class is a part of the Ruby core library while `[]` is an instance of the Array class.
    # When calling [].methods, we inspect the methods available to instances of the Array class, including those inherited from its class and ancestors.
    def infer_klass
      return klass if klass != "Array"

      "[]"
    end

    def built_in_klass
      infer_klass == "[]"
    end
  end
end
