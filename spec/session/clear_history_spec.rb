# frozen_string_literal: true

RSpec.describe Session::ClearHistory do
  subject { described_class.call(pry) }

  let(:pry) { Pry.new(output: StringIO.new) }
  let(:store) { PStore.new(ENV["BYETYPO_STORE_PATH"]) }
  let(:pry_instance_uid) { "pry_instance_1234" }
  let(:table_data) { "variable" }

  before do
    allow(PStore).to receive(:new).and_return(store)
    store.transaction do |store|
      store[pry_instance_uid] = [table_data]
    end
    allow(pry).to receive(:push_initial_binding).and_return([pry_instance_uid])
  end

  it "clears the table of the initial binding" do
    expect(store.transaction { store[pry_instance_uid] }).to eq([table_data])
    subject
    expect(store.transaction { store[pry_instance_uid] }).to be_nil
  end
end
