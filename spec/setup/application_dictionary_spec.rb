# frozen_string_literal: true

require "zeitwerk"
require "active_record"

class PostgreSQLAdapter
  def tables
    ["users", "accounts", "deals"]
  end
end

RSpec.describe Setup::ApplicationDictionary do
  subject { described_class.call(pry_instance_uid) }

  let(:pry_instance_uid) { 1234 }
  let(:store) { PStore.new(ENV["BYETYPO_STORE_PATH"]) }

  before { allow(PStore).to receive(:new).and_return(store) }

  context "given ActiveRecord defined" do
    before do
      store.transaction do
        store.delete(pry_instance_uid)
        store.delete("active_record_models")
        store.delete("associations")
        store.delete("synced_at")
      end

      allow(Zeitwerk::Loader).to receive(:eager_load_all)
      allow(ActiveRecord::Base).to receive(:establish_connection)
      allow(ActiveRecord::Base).to receive(:connection).and_return(PostgreSQLAdapter.new)
    end

    it "calls Setup::Dictionary::ActiveRecord" do
      expect(Setup::Dictionary::ActiveRecord).to receive(:initialize!).and_return(nil)

      subject
    end

    it "create the `pry_instance_uid` table" do
      subject

      expect(store.transaction { store[pry_instance_uid.to_s] }).to eq([])
    end
  end
end
