# frozen_string_literal: true

require "pry"
require "zeitwerk"

require_relative "pry-byetypo/version"
require_relative "pry-byetypo/setup/application_dictionary"
require_relative "pry-byetypo/exceptions_handler"

module Pry::Byetypo
  Pry.config.hooks.add_hook(:before_session, :eager_loading) do |output, exception, pry|
    Setup::ApplicationDictionary.new
  end

  # TODO: Adds max_attempts
  # TODO: If max_attempt reached clean the last entries (eg: max entry 3 has been reached, we remove the last 3 history entries)
  Pry.config.exception_handler = proc do |output, exception, pry|
    ExceptionsHandler.call(output, exception, pry)
  end
end
