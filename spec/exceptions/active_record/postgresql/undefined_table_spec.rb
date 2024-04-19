# frozen_string_literal: true

require "active_record"

RSpec.describe Exceptions::ActiveRecord::Postgresql::UndefinedTable do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:exception) { ActiveRecord::StatementInvalid.new("PG::UndefinedTable: ERROR:  missing FROM-clause entry for table \"paychck\"\nLINE 1: ...\" = \"paychecks\".\"paycheck_id\" WHERE \"paych...\n                                                             ^\n") }
  let(:last_cmd) { "User.joins(:paycheck).where(paychck: {month: \"june\"}).last" }
  let(:corrected_cmd) { "User.joins(:paycheck).where(paycheck: {month: \"june\"}).last" }
  let(:store_path) { "./spec/support/byetypo_dictionary_test.pstore" }

  describe "#call" do
    before do
      PStore.new(store_path).transaction do |store|
        store["associations"] = ["user", "users", "paycheck", "paychecks"]
      end
      allow(Pry).to receive(:line_buffer).and_return([last_cmd])
    end

    it "outputs a corrected command and runs it" do
      expect(pry).to receive(:eval).with(corrected_cmd)
      subject
    end
  end
end
