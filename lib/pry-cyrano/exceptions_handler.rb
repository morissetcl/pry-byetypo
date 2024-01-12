# frozen_string_literal: true

require_relative "base"
require_relative "exceptions/active_record/statement_invalid"
require_relative "exceptions/active_record/configuration_error"
require_relative "exceptions/name_error"

class ExceptionsHandler < Base
  attr_reader :exception, :output, :pry

  def initialize(output, exception, pry)
    @output = output
    @exception = exception
    @pry = pry
  end

  def call
    case exception
    in NameError
      # SurveyRespon.last
      Exceptions::NameError.call(output, exception, pry)
    in ActiveRecord::StatementInvalid
      # SurveyResponse.joins(:survey_question).where(survey_quesion: {title: "ok"}).last
      Exceptions::ActiveRecord::StatementInvalid.call(output, exception, pry)
    in ActiveRecord::ConfigurationError
      # SurveyResponse.joins(:survey_questions).where(survey_question: {title: "ok"}).last
      Exceptions::ActiveRecord::ConfigurationError.call(output, exception, pry)
    else
      Pry::ExceptionHandler.handle_exception(output, exception, pry)
    end
  end
end
