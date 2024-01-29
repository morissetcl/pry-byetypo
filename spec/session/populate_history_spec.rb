# frozen_string_literal: true

RSpec.describe Session::PopulateHistory do
  subject { described_class.call(pry) }

  let(:pry) { Pry.new }
  let(:store) { PStore.new(ENV["BYETYPO_STORE_PATH"]) }
  let(:binding_name) { "binding1234" }

  before do
    allow(PStore).to receive(:new).and_return(store)
    store.transaction { store[binding_name] = [] }
    allow(pry).to receive(:binding_stack).and_return([binding_name])
    allow(pry).to receive(:eval_string).and_return("test\n")
  end

  it "clears the table of the initial binding" do
    expect(store.transaction { store[binding_name] }).to eq([])
    subject
    expect(store.transaction { store[binding_name] }).to eq(["test"])
  end
end
