# frozen_string_literal: true

RSpec.describe Exceptions::ActiveRecord::StatementInvalid::Handler do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }

  describe "#call" do
    context "given an undefined table error" do
      let(:exception) { ActiveRecord::StatementInvalid.new("PG::UndefinedTable: ERROR:  missing FROM-clause entry for table \"paychck\"\nLINE 1: ...\" = \"paychecks\".\"paycheck_id\" WHERE \"paych...\n                                                             ^\n") }

      it "calls UndefinedTable service" do
        expect(Exceptions::ActiveRecord::StatementInvalid::UndefinedTable).to receive(:call).with(output, exception, pry)
        subject
      end
    end

    context "given an undefined column error" do
      let(:exception) { ActiveRecord::StatementInvalid.new("PG::UndefinedColumn: ERROR:  column users.emal does not exist\nLINE 1: ...OM \"users\" WHERE \"users\".\"deleted_at\" IS NULL AND \"users\".\"e...\n                                                             ^\nHINT:  Perhaps you meant to reference the column \"users.email\".\n") }

      it "calls UndefinedColumn service" do
        expect(Exceptions::ActiveRecord::StatementInvalid::UndefinedColumn).to receive(:call).with(output, exception, pry)
        subject
      end
    end

    context "given an error not handled" do
      let(:exception) { ActiveRecord::StatementInvalid.new("random error") }

      it "calls UndefinedColumn service" do
        expect(Pry::ExceptionHandler).to receive(:handle_exception).with(output, exception, pry)
        subject
      end
    end
  end
end
