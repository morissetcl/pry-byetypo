# frozen_string_literal: true

class Base
  class << self
    def call(...)
      new(...).call
    end
  end
end