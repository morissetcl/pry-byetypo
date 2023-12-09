# frozen_string_literal: true

require "pry"
require "zeitwerk"

require_relative "pry-cyrano/version"
require_relative "pry-cyrano/setup/application_dictionary"
require_relative "pry-cyrano/exception_handler"

module Pry::Cyrano
  Pry.config.hooks.add_hook(:before_session, :eager_loading) do |output, exception, pry|
    dictionary_instance = Setup::ApplicationDictionary.new
    @application_dictionary = {
      ar_models_dictionary: dictionary_instance.active_record_models,
      associations_dictionary: dictionary_instance.associations
    }
  end

  # TODO: Adds max_attempts
  # TODO: If max_attempt reached clean the last entries (eg: max entry 3 has been reached, we remove the last 3 history entries)
  Pry.config.exception_handler = proc do |output, exception, pry|
    ExceptionHandler.call(output, exception, pry, @application_dictionary)
  end
end
