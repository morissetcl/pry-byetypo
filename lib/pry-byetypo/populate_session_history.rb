# frozen_string_literal: true

require "byebug"

require_relative "base"
require_relative "setup/store"

class PopulateSessionHistory < Base
  include Setup::Store

  attr_reader :binding

  def initialize(binding)
    @binding = binding
  end

  def call
    store.transaction do
      store[binding.binding_stack.join].push(binding.eval_string.strip)
    end
  end
end
