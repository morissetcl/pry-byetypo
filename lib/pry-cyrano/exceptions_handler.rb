# frozen_string_literal: true

require_relative "base"
require_relative "exceptions/uninitialized_constant"
require_relative "exceptions/missing_from_clause_entry_table"
require_relative "exceptions/active_record_configuration_error"

class ExceptionsHandler < Base
  attr_reader :exception, :output, :pry, :ar_models_dictionary, :associations_dictionary

  def initialize(output, exception, pry, application_dictionary)
    @output = output
    @exception = exception
    @pry = pry
    @ar_models_dictionary = application_dictionary[:ar_models_dictionary]
    @associations_dictionary = application_dictionary[:associations_dictionary]
  end

  def call
    case exception
    in NameError
      # SurveyRespon.last
      Exceptions::UninitializedConstant.call(output, exception, pry, ar_models_dictionary)
    in ActiveRecord::StatementInvalid
      # SurveyResponse.joins(:survey_question).where(survey_quesion: {title: "ok"}).last
      Exceptions::MissingFromClauseEntryTable.call(output, exception, pry, associations_dictionary)
    in ActiveRecord::ConfigurationError
      # SurveyResponse.joins(:survey_questions).where(survey_question: {title: "ok"}).last
      Exceptions::ActiveRecordConfigurationError.call(output, exception, pry, associations_dictionary)
    else
      Pry::ExceptionHandler.handle_exception(output, @exception, pry)
    end
  end
end
