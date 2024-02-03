# frozen_string_literal: true

require "logger"
require "colorize"
require_relative "../base"
require_relative "../setup/store"

class ExceptionsBase < Base
  include Setup::Store

  def call
    if corrected_word
      logger.error(exception.to_s.colorize(color: :light_red, mode: :bold))
      logger.info("Running: #{corrected_cmd}".colorize(color: :green, mode: :bold))

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
