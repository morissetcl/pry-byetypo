# frozen_string_literal: true

require "active_record"

RSpec.describe Exceptions::ActiveRecord::StatementInvalid::UndefinedColumn do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:last_cmd) { "User.find_by(emal: 'yo@email.com')" }
  let(:corrected_cmd) { "User.find_by(email: 'yo@email.com')" }

  describe "#call" do
    before { allow(Pry).to receive(:line_buffer).and_return([last_cmd]) }

    context "given a corrected command" do
      let(:exception) { ActiveRecord::StatementInvalid.new("PG::UndefinedColumn: ERROR:  column users.emal does not exist\nLINE 1: ...OM \"users\" WHERE \"users\".\"deleted_at\" IS NULL AND \"users\".\"e...\n                                                             ^\nHINT:  Perhaps you meant to reference the column \"users.email\".\n") }

      it "outputs a corrected command and runs it" do
        expect(pry).to receive(:eval).with(corrected_cmd)
        subject
      end
    end

    context "given an exception without hint" do
      let(:exception) { ActiveRecord::StatementInvalid.new("PG::UndefinedColumn: ERROR:  column users.emal does not exist\nLINE 1: ...OM \"users\" WHERE \"users\".\"deleted_at\" IS NULL AND \"users\".\"e...\n") }

      it "runs Pry::ExceptionHandler" do
        expect(Pry::ExceptionHandler).to receive(:handle_exception).with(output, exception, pry)
        subject
      end
    end
  end
end
