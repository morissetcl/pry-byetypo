# frozen_string_literal: true

require_relative "../base"
require_relative "../setup/store"

module Session
  class ClearHistory < Base
    include Setup::Store

    attr_reader :pry

    def initialize(pry)
      @pry = pry
    end

    def call
      pry_instance_to_remove = pry.push_initial_binding.join
      store.transaction { store.delete(pry_instance_to_remove) }
    end
  end
end
