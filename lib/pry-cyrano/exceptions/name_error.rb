# frozen_string_literal: true

require_relative "exceptions_base"

module Exceptions
  class NameError < ExceptionsBase
    private

    def infer_cmd
      logger.info("🤓 #{unknown_from_exception} does not exist, running the command with #{corrected_word} assuming is what you meant. 🤓")
      logger.info("🤓  running #{corrected_cmd} 🤓")

      pry.eval(corrected_cmd)
    end

    def unknown_from_exception
      exception.to_s.split.last
    end

    def corrected_word
      @corrected_word ||= spell_checker(ar_models_dictionary).correct(unknown_from_exception).first
    end

    def corrected_cmd
      @corrected_cmd ||= last_cmd.gsub(unknown_from_exception, corrected_word)
    end

    def ar_models_dictionary
      @ar_models_dictionary ||= store.transaction { |s| s["active_record_models"] }
    end
  end
end
