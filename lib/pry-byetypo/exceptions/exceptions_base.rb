# frozen_string_literal: true

require_relative "../base"
require_relative "../setup/store"
require "colorize"

class ExceptionsBase < Base
  include Setup::Store

  def call
    logger.info("`#{unknown_from_exception}` not working, running:".colorize(color: :green, mode: :bold))
    logger.info(corrected_cmd.to_s.colorize(color: :green, mode: :bold))

    pry.eval(corrected_cmd)
  end

  private

  attr_reader :exception, :output, :pry

  def initialize(output, exception, pry)
    @output = output
    @exception = exception
    @pry = pry
  end

  def spell_checker(dictionary)
    DidYouMean::SpellChecker.new(dictionary: dictionary)
  end

  def logger
    @logger = Logger.new($stdout)
  end

  def last_cmd
    @last_cmd ||= Pry.line_buffer.last.strip
  end
end
