# frozen_string_literal: true

require "pry-byetypo"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.before(:suite) do
    ENV["BYETYPO_STORE_PATH"] = "./spec/support/byetypo_dictionary_test.pstore"
    ENV["DB_CONFIG_PATH"] = "spec/support/config/database.yml"
  end
end
