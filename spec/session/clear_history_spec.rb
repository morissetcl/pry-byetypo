# frozen_string_literal: true

RSpec.describe Session::ClearHistory do
  subject { described_class.call(pry) }

  let(:pry) { Pry.new(output: StringIO.new) }
  let(:store) { PStore.new(ENV["BYETYPO_STORE_PATH"]) }
  let(:table) { "binding" }
  let(:table_data) { "variable" }

  before do
    allow(PStore).to receive(:new).and_return(store)
    store.transaction do |store|
      store[table] = [table_data]
    end
    allow(pry).to receive(:push_initial_binding).and_return([table])
  end

  it "clears the table of the initial binding" do
    expect(store.transaction { store[table] }).to eq([table_data])
    subject
    expect(store.transaction { store[table] }).to be_nil
  end
end
