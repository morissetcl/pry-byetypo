# frozen_string_literal: true

class User
  def employee?
    true
  end
end


RSpec.describe Exceptions::NoMethodError do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }

  
  describe "#call" do
    before { allow(Pry).to receive(:line_buffer).and_return([last_cmd]) }

    context "given Rails::VERSION::MAJOR == 8" do
      context "given an instance method" do
        context "given an undefined method for a model" do
          let(:last_cmd) { "User.last.employee" }
          let(:exception) { NoMethodError.new("undefined method `employee' for an instance of User (NoMethodError)") }
          let(:corrected_cmd) { "User.last.employee?" }

          it "outputs a corrected command and runs it" do
            expect(pry).to receive(:eval).with(corrected_cmd)
            subject
          end
        end
      end

      context "given a class method" do
        let(:last_cmd) { "User.freze" }
        let(:exception) { NoMethodError.new("undefined method `freze' for class User") }
        let(:corrected_cmd) { "User.freeze" }

        it "outputs a corrected command and runs it" do
          expect(pry).to receive(:eval).with(corrected_cmd)
          subject
        end
      end

      context "given an undefined method for a built in class" do
        let(:last_cmd) { "[1].firsst" }
        let(:exception) { NoMethodError.new("undefined method `firsst' for an instance of Array (NoMethodError)") }
        let(:corrected_cmd) { "[1].first" }

        it "outputs a corrected command and runs it" do
          Rails.application.eager_load!

          expect(pry).to receive(:eval).with(corrected_cmd)
          subject
        end
      end
    end

    context "given Rails::VERSION::MAJOR == 7" do
      context "given an instance method" do
        context "given an undefined method for a model" do
          let(:last_cmd) { "User.last.employee" }
          let(:exception) { NoMethodError.new("undefined method `employee' for #<User id: 37..>") }
          let(:corrected_cmd) { "User.last.employee?" }

          it "outputs a corrected command and runs it" do
            expect(pry).to receive(:eval).with(corrected_cmd)
            subject
          end
        end
      end

      context "given an undefined method for a built in class" do
        let(:last_cmd) { "[1].firsst" }
        let(:exception) { NoMethodError.new("undefined method `firsst' for an instance of Array (NoMethodError)") }
        let(:corrected_cmd) { "[1].first" }

        it "outputs a corrected command and runs it" do
          expect(pry).to receive(:eval).with(corrected_cmd)
          subject
        end
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
