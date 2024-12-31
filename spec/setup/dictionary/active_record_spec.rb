# frozen_string_literal: true

require "zeitwerk"
require "active_record"

class TestUser < ActiveRecord::Base
  has_many :deals
end

module Account
  class Deal < ActiveRecord::Base
    belongs_to :user
  end
end

RSpec.describe Setup::Dictionary::ActiveRecord do
  subject { described_class.initialize! }

  let(:pry_instance_uid) { 1234 }
  let(:store) { PStore.new(ENV["BYETYPO_STORE_PATH"]) }
  let(:current_time) { Time.new(2024, 11, 1, 15, 25, 0, "+09:00") }

  before do
    allow(PStore).to receive(:new).and_return(store)
    # Reset store
    store.transaction do
      store.delete(pry_instance_uid)
      store.delete("active_record_models")
      store.delete("associations")
      store.delete("synced_at")
    end

    allow(Zeitwerk::Loader).to receive(:eager_load_all)
    allow(ActiveRecord::Base).to receive(:establish_connection)
  end

  context "given a staled store" do
    it "calls checks" do
      expect(Setup::Checks::DatabaseUrl).to receive(:check)
      expect(Setup::Checks::DatabasePool).to receive(:check)

      subject
    end

    it "populates stores with associations" do
      subject

      expect(store.transaction { store["associations"] }).to match_array([:deals, :user])
    end

    it "populates stores with ActiveRecord::Base.methods" do
      subject

      expect(store.transaction { store["ar_methods"] }).to match_array(::ActiveRecord::Base.methods)
    end

    it "populates stores with active_record_models" do
      subject

      expect(store.transaction { store["active_record_models"] }).to match_array(["TestUser", "Account::Deal", "Account", "Deal"])
    end

    it "populates stores with synced_at" do
      allow(Time).to receive(:now).and_return(current_time)

      subject

      expect(store.transaction { store["synced_at"] }).to eq(current_time)
    end
  end

  context "given a staled store" do
    before do
      allow(Time).to receive(:now).and_return(current_time)
      store.transaction { store["synced_at"] = current_time }
    end

    it "populates stores with synced_at" do
      subject

      expect(store.transaction { store["synced_at"] }).to eq(current_time)
    end

    it "does not populates stores with active_record_models" do
      subject

      expect(store.transaction { store["active_record_models"] }).to be_nil
    end

    it "does not populates stores with associations" do
      subject

      expect(store.transaction { store["associations"] }).to be_nil
    end
  end
end
