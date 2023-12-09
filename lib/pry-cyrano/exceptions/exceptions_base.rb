# frozen_string_literal: true

require_relative "../base"

class ExceptionsBase < Base
  def call
    correct_error
  end

  private

  attr_reader :exception, :output, :pry, :dictionary

  def initialize(output, exception, pry, dictionary)
    @output = output
    @exception = exception
    @pry = pry
    @dictionary = dictionary
  end

  def spell_checker(dictionary)
    DidYouMean::SpellChecker.new(dictionary: dictionary)
  end
end
