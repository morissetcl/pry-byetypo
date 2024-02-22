# frozen_string_literal: true

class User; end

RSpec.describe Exceptions::NoMethodError do
  subject { described_class.call(output, exception, pry) }

  let(:output) { Pry::Output.new(pry) }
  let(:pry) { Pry.new(output: StringIO.new) }
  let(:exception) { NoMethodError.new("undefined method `ancestrs' for User:Class") }
  let(:last_cmd) { "User.ancestrs" }
  let(:corrected_cmd) { "User.ancestors" }

  describe "#call" do
    before { allow(Pry).to receive(:line_buffer).and_return([last_cmd]) }

    it "outputs a corrected command and runs it" do
      expect(pry).to receive(:eval).with(corrected_cmd)
      subject
    end
  end
end
