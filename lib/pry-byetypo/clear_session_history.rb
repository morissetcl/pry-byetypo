# frozen_string_literal: true

require_relative "base"
require_relative "setup/store"

class ClearSessionHistory < Base
  include Setup::Store

  attr_reader :pry

  def initialize(pry)
    @pry = pry
  end

  def call
    binding_to_remove = pry.push_initial_binding.join
    store.transaction { store.delete(binding_to_remove) }
  end
end
