# frozen_string_literal: true

require "active_record"

RSpec.describe Exceptions::NameError do
  subject { described_class.call(output, exception, pry, dictionnary) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:dictionnary) { ["User"] }
  let(:exception) { NameError.new("uninitialized constant Use") }
  let(:last_cmd) { "Use.last" }
  let(:corrected_cmd) { "User.last" }

  describe "#call" do
    before { allow(Pry).to receive(:line_buffer).and_return([last_cmd]) }

    it "outputs a corrected command and runs it" do
      expect(pry).to receive(:eval).with(corrected_cmd)
      subject
    end
  end
end
