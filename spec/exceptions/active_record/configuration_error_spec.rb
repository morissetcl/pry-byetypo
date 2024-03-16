# frozen_string_literal: true

RSpec.describe Exceptions::ActiveRecord::ConfigurationError do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:exception) { ActiveRecord::ConfigurationError.new("Can't join 'User' to association named 'paychecks'; perhaps you misspelled it?") }
  let(:last_cmd) { "User.joins(:paychecks).where(paycheck: {month: \"june\"}).last" }
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
