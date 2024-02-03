# frozen_string_literal: true

RSpec.describe Session::PopulateHistory do
  subject { described_class.call(pry) }

  let(:pry) { Pry.new }
  let(:store) { PStore.new(ENV["BYETYPO_STORE_PATH"]) }
  let(:pry_instance_uid) { "binding1234" }

  before do
    allow(PStore).to receive(:new).and_return(store)
    store.transaction { store[pry_instance_uid] = [] }
    allow(pry).to receive(:binding_stack).and_return([pry_instance_uid])
    allow(pry).to receive(:eval_string).and_return(variables)
  end

  context "given variable who is not eligible to be stored" do
    let(:variables) { "variable" }

    it "does not populate the table" do
      expect(store.transaction { store[pry_instance_uid] }).to eq([])
      subject
      expect(store.transaction { store[pry_instance_uid] }).to eq([])
    end
  end

  context "given a variable who is eligible to be stored" do
    context "given a regular variable assignement" do
      let(:variables) { "user_last = User.last" }

      it "populates the table of the current pry instance" do
        expect(store.transaction { store[pry_instance_uid] }).to eq([])
        subject
        expect(store.transaction { store[pry_instance_uid] }).to eq(["user_last"])
      end
    end

    context "given parallel variables assignement" do
      let(:variables) { "user_last,user_first = User.last, User,first" }

      it "populates the table of the current pry instance" do
        expect(store.transaction { store[pry_instance_uid] }).to eq([])
        subject
        expect(store.transaction { store[pry_instance_uid] }).to eq(["user_last", "user_first"])
      end
    end
  end
end
