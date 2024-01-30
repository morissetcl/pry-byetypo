# frozen_string_literal: true

RSpec.describe Exceptions::NameError::Base do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:exception) { NameError.new("uninitialized constant Use") }

  describe "#call" do
    context "given a UNINITIALIZED_CONSTANT exception" do
      let(:exception) { NameError.new("uninitialized constant Use") }

      it "calls Exceptions::NameError::UninitializedConstant" do
        expect(Exceptions::NameError::UninitializedConstant).to receive(:call).with(output, exception, pry)
        subject
      end
    end

    context "given a UNDEFINED_VARIABLE exception" do
      let(:exception) { NameError.new("undefined local variable") }

      it "calls Exceptions::NameError::UndefinedVariable" do
        expect(Exceptions::NameError::UndefinedVariable).to receive(:call).with(output, exception, pry)
        subject
      end
    end

    context "given another NameError exception" do
      let(:exception) { NameError.new("other NameError exception") }

      it "calls Pry::ExceptionHandler" do
        expect(Pry::ExceptionHandler).to receive(:handle_exception).with(output, exception, pry)
        subject
      end
    end
  end
end
