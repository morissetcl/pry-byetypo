# frozen_string_literal: true

require "pry-byetypo"
require "active_record"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.before(:suite) { ENV["BYETYPO_STORE_PATH"] = "./spec/support/byetypo_dictionary_test.pstore" }
end
