# frozen_string_literal: true

require "active_record"

RSpec.describe ExceptionsHandler do
  subject { described_class.call(output, exception, pry, application_dictionary) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:application_dictionary) { {ar_models_dictionary: ["User"], associations_dictionary: ["users", "user"]} }

  context "given a NameError" do
    let(:exception) { NameError.new }

    it "calls Exceptions::UninitializedConstant error" do
      expect(Exceptions::UninitializedConstant).to receive(:call).with(output, exception, pry, application_dictionary[:ar_models_dictionary])
      subject
    end
  end

  context "given a ActiveRecord::StatementInvalid error" do
    let(:exception) { ActiveRecord::StatementInvalid.new }

    it "calls Exceptions::MissingFromClauseEntryTable" do
      expect(Exceptions::MissingFromClauseEntryTable).to receive(:call).with(output, exception, pry, application_dictionary[:associations_dictionary])
      subject
    end
  end

  context "given a ActiveRecord::ConfigurationError error" do
    let(:exception) { ActiveRecord::ConfigurationError.new }

    it "calls Exceptions::ActiveRecordConfigurationError" do
      expect(Exceptions::ActiveRecordConfigurationError).to receive(:call).with(output, exception, pry, application_dictionary[:associations_dictionary])
      subject
    end
  end
end
