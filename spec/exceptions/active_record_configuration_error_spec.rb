# frozen_string_literal: true

require "active_record"

RSpec.describe Exceptions::ActiveRecordConfigurationError do
  subject { described_class.call(output, exception, pry, dictionnary) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:dictionnary) {  ["paychecks", "paycheck"] }
  let(:exception) { ActiveRecord::ConfigurationError.new("Can\'t join 'User' to association named 'paychecks'; perhaps you misspelled it?") }
  let(:last_cmd) {  "User.joins(:paychecks).where(paycheck: {month: \"june\"}).last" }
  let(:correct_cmd) { "User.joins(:paycheck).where(paycheck: {month: \"june\"}).last" }

  describe "#call" do
    before { allow(Pry).to receive(:line_buffer).and_return([last_cmd]) }

    it "outputs a corrected command and runs it" do
      expect(pry).to receive(:eval).with(correct_cmd)
      subject
    end
  end
end
