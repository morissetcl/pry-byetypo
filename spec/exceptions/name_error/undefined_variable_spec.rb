# frozen_string_literal: true

RSpec.describe Exceptions::NameError::UndefinedVariable do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:exception) { NameError.new("undefined local variable or method `resilt' for main:Object") }
  let(:last_cmd) { "resilt" }
  let(:corrected_cmd) { "result" }
  let(:store_path) { "./spec/support/byetypo_dictionary_test.pstore" }
  let(:store) { PStore.new(store_path) }

  describe "#call" do
    before do
      allow(PStore).to receive(:new).and_return(store)
      PStore.new(store_path).transaction do |store|
        store["binding1234"] = ["result"]
      end
      allow(pry).to receive(:current_binding).and_return("binding1234")
      allow(Pry).to receive(:line_buffer).and_return([last_cmd])
    end

    it "outputs a corrected command and runs it" do
      expect(pry).to receive(:eval).with(corrected_cmd)
      subject
    end
  end
end
