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
      @dictionary ||= begin
        _klass = eval(infer_klass)  # rubocop:disable Security/Eval
        klass_methods = _klass.methods
        instance_methods = _klass.respond_to?(:instance_methods) ? _klass.instance_methods(false) : []
        column_names = _klass.respond_to?(:column_names) ? _klass.column_names : []

        [instance_methods, klass_methods, model_associations, column_names, active_records_methods].flatten.map(&:to_s)
      end
    end

    def model_associations
      store.transaction { |s| [s["associations"]] }
    end

    def active_records_methods
      store.transaction { |s| [s["ar_methods"]] }
    end


    def exception_regexp
      /`([^']+)' for/
    end

    def klass_regexp
      return /for an instance of (\w+)/ if instance_exception?
      return /for class (\w+)/ if exception.to_s.include?("class")

      /for #<(\w+)/
    end

    def klass
      @klass ||= begin
        exception_without_class_module = exception.to_s.match(klass_regexp)
        exception_without_class_module[1]
      end
    end

    def instance_exception?
      exception.to_s.include?("for an instance of")
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
