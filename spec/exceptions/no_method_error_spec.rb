# frozen_string_literal: true

class User; end

RSpec.describe Exceptions::NoMethodError do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }

  describe "#call" do
    before { allow(Pry).to receive(:line_buffer).and_return([last_cmd]) }

    context "given an undefined method for a model" do
      let(:last_cmd) { "User.ancestrs" }
      let(:exception) { NoMethodError.new("undefined method `ancestrs' for User:Class") }
      let(:corrected_cmd) { "User.ancestors" }

      it "outputs a corrected command and runs it" do
        expect(pry).to receive(:eval).with(corrected_cmd)
        subject
      end
    end

    context "given an undefined method for a built in class" do
      let(:last_cmd) { "[1].firsst" }
      let(:exception) { NoMethodError.new("undefined method `firsst' for an instance of Array") }
      let(:corrected_cmd) { "[1].first" }

      it "outputs a corrected command and runs it" do
        expect(pry).to receive(:eval).with(corrected_cmd)
        subject
      end
    end

    context "given an undefined method error not linked to a REPL typo" do
      let(:last_cmd) { "UserAccount.perform(user)" }
      let(:exception) { NoMethodError.new("undefined method `is_loaded?' for Account") }

      it "does not try to correct the last command" do
        expect(Pry::ExceptionHandler).to receive(:handle_exception)
        subject
      end
    end
  end
end
