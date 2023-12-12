# frozen_string_literal: true

require "active_record"

RSpec.describe ExceptionsHandler do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:application_dictionary) { {ar_models_dictionary: ["User"], associations_dictionary: ["users", "user"]} }

  context "given a NameError" do
    let(:exception) { NameError.new }

    it "calls Exceptions::NameError error" do
      expect(Exceptions::NameError).to receive(:call).with(output, exception, pry)
      subject
    end
  end

  context "given a ActiveRecord::StatementInvalid error" do
    let(:exception) { ActiveRecord::StatementInvalid.new }

    it "calls Exceptions::ActiveRecordStatementInvalid" do
      expect(Exceptions::ActiveRecordStatementInvalid).to receive(:call).with(output, exception, pry)
      subject
    end
  end

  context "given a ActiveRecord::ConfigurationError error" do
    let(:exception) { ActiveRecord::ConfigurationError.new }

    it "calls Exceptions::ActiveRecordConfigurationError" do
      expect(Exceptions::ActiveRecordConfigurationError).to receive(:call).with(output, exception, pry)
      subject
    end
  end
end
