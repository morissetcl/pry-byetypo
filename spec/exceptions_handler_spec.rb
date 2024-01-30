# frozen_string_literal: true

RSpec.describe ExceptionsHandler do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:application_dictionary) { {ar_models_dictionary: ["User"], associations_dictionary: ["users", "user"]} }

  context "given a NameError" do
    let(:exception) { NameError.new(Constants::Errors::UNINITIALIZED_CONSTANT) }

    it "calls Exceptions::NameError::Base error" do
      expect(Exceptions::NameError::Handler).to receive(:call).with(output, exception, pry)
      subject
    end
  end

  context "given a ActiveRecord::StatementInvalid error" do
    context "given a ActiveRecord::StatementInvalid related to undefined table" do
      let(:exception) { ActiveRecord::StatementInvalid.new(Constants::Errors::UNDEFINED_TABLE) }

      it "calls Exceptions::ActiveRecord::StatementInvalid" do
        expect(Exceptions::ActiveRecord::StatementInvalid).to receive(:call).with(output, exception, pry)
        subject
      end
    end

    context "given a ActiveRecord::StatementInvalid not related to undefined table" do
      let(:exception) { ActiveRecord::StatementInvalid.new }

      it "calls Pry::ExceptionHandler" do
        expect(Pry::ExceptionHandler).to receive(:handle_exception)
        subject
      end
    end
  end

  context "given a ActiveRecord::ConfigurationError error" do
    let(:exception) { ActiveRecord::ConfigurationError.new }

    it "calls Exceptions::ActiveRecordConfigurationError" do
      expect(Exceptions::ActiveRecord::ConfigurationError).to receive(:call).with(output, exception, pry)
      subject
    end
  end
end
