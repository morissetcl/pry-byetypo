# frozen_string_literal: true

RSpec.describe Exceptions::ActiveRecord::UninitializedConstant do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:dictionnary) { ["User"] }
  let(:exception) { NameError.new("uninitialized constant Use") }
  let(:last_cmd) { "Use.last" }
  let(:corrected_cmd) { "User.last" }
  let(:store_path) { "./spec/support/byetypo_dictionary_test.pstore" }

  describe "#call" do
    before do
      PStore.new(store_path).transaction do |store|
        store["active_record_models"] = ["User", "Paycheck"]
      end
      allow(Pry).to receive(:line_buffer).and_return([last_cmd])
    end

    it "outputs a corrected command and runs it" do
      expect(pry).to receive(:eval).with(corrected_cmd)
      subject
    end
  end
end
