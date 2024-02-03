# frozen_string_literal: true

require_relative "../base"
require_relative "store"
require_relative "dictionary/active_record"
require "pstore"

module Setup
  class ApplicationDictionary < Base
    include Store

    def initialize(binding)
      @binding = binding
    end

    def call
      Setup::Dictionary::ActiveRecord.initialize! if defined?(ActiveRecord)
      populate_store
    end

    private

    attr_reader :binding

    def populate_store
      # Create a table with unique instance identifier information to store variables history.
      store.transaction { store[pry_instance_uid] = [] }
    end

    # Use the binding identifier as pry instance uid.
    def pry_instance_uid
      binding.to_s
    end
  end
end
