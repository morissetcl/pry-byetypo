# frozen_string_literal: true

require "pry"

require_relative "pry-byetypo/setup/application_dictionary"
require_relative "pry-byetypo/session/clear_history"
require_relative "pry-byetypo/exceptions_handler"
require_relative "pry-byetypo/session/populate_history"
require_relative "pry-byetypo/version"

module Pry::Byetypo
  Pry.config.hooks.add_hook(:before_session, :create_dictionary) do |_output, binding, _pry|
    Setup::ApplicationDictionary.call(binding)
  end

  Pry.config.hooks.add_hook(:after_read, :populate_session_history) do |_output, binding, _pry|
    Session::PopulateHistory.call(binding)
  end

  Pry.config.hooks.add_hook(:after_session, :clear_session_history) do |_output, _binding, pry|
    Session::ClearHistory.call(pry)
  end

  # TODO: Adds max_attempts
  # TODO: If max_attempt reached clean the last entries (eg: max entry 3 has been reached, we remove the last 3 history entries)
  Pry.config.exception_handler = proc do |output, exception, pry|
    ExceptionsHandler.call(output, exception, pry)
  end
end
