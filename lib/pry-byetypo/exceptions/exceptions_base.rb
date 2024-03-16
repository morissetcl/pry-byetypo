# frozen_string_literal: true

require "logger"
require_relative "../base"
require_relative "../setup/store"

class ExceptionsBase < Base
  include Setup::Store

  def call
    if can_correct?
      logger.error("\e[1;31m#{exception}\e[0m")
      logger.info("\e[1;32mRunning: #{corrected_cmd}\e[0m")

      pry.eval(corrected_cmd)
    else
      Pry::ExceptionHandler.handle_exception(output, exception, pry)
    end
  end

  private

  attr_reader :exception, :output, :pry

  def initialize(output, exception, pry)
    @output = output
    @exception = exception
    @pry = pry
  end

  def can_correct?
    dictionary && corrected_word
  end

  def corrected_word
    @corrected_word ||= spell_checker.correct(unknown_from_exception).first
  end

  def spell_checker
    DidYouMean::SpellChecker.new(dictionary: dictionary)
  end

  def logger
    @logger = Logger.new($stdout)
  end

  def last_cmd
    @last_cmd ||= Pry.line_buffer.last.strip
  end
end
