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
      return unless is_assignement_variables?

      store.transaction do
        store.abort unless variables_to_store

        store[pry_instance_uid].push(*variables_to_store)
      end
    end

    private

    # Unique instance identifier (e.g., a Pry opened tab)
    def pry_instance_uid
      binding.binding_stack.join
    end

    def variables_to_store
      @variables_to_store ||= last_cmd.split("=").first.strip.split(",")
    end

    def last_cmd
      binding.eval_string.strip
    end

    # Returns true if the last command seems to be an assignment of variables, false otherwise.
    #
    # Examples
    #
    #   is_assignment_variables?("user_last, user_first = User.last, User.first")
    #   # => true
    #
    #   is_assignment_variables?("user_last = User.last")
    #   # => true
    #
    #   is_assignment_variables?("user_last")
    #   # => false
    def is_assignement_variables?
      last_cmd.include?("=")
    end
  end
end
