# frozen_string_literal: true

require_relative "../base"

class ExceptionsBase < Base
  def call
    correct_error
  end

  private

  attr_reader :exception, :output, :pry

  def initialize(output, exception, pry)
    @output = output
    @exception = exception
    @pry = pry
  end

  def associations_dictionary
    @associations_dictionary ||= store.transaction { |s| s["associations"] }
  end

  def ar_models_dictionary
    @ar_models_dictionary ||= store.transaction { |s| s["active_record_models"] }
  end

  def spell_checker(dictionary)
    DidYouMean::SpellChecker.new(dictionary: dictionary)
  end

  def store
    PStore.new("cyrano_dictionary.pstore")
  end

  def logger
    @logger = Logger.new($stdout)
  end
end
