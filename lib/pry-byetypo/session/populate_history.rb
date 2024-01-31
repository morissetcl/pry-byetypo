# frozen_string_literal: true

require_relative "../base"
require_relative "../setup/store"

module Session
  class PopulateHistory < Base
    include Setup::Store

    attr_reader :binding

    def initialize(binding)
      @binding = binding
    end

    def call
      store.transaction do
        store.abort unless extract_variable_to_store

        store[pry_instance_uid].push(variable_to_store)
      end
    end

    private

    # Unique instance identifier (e.g., a Pry opened tab)
    def pry_instance_uid
      binding.binding_stack.join
    end

    def extract_variable_to_store
      @extract_variable_to_store ||= last_cmd.match(/^(\w+)\s*=/)
    end

    def last_cmd
      binding.eval_string.strip
    end

    def variable_to_store
      extract_variable_to_store[1]
    end
  end
end
