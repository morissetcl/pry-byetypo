# frozen_string_literal: true

require "logger"

RSpec.describe Setup::Checks::DatabasePool do
  subject { described_class.check(database_config, logger) }

  let(:database_pool) { "25" }
  let(:database_config) { {"adapter" => "postgresql", "encoding" => "unicode", "pool" => database_pool, "url" => "database_url"} }
  let(:logger) { Logger.new($stdout) }

  context "given a configuration with a valied database_pool" do
    it "does not raise error" do
      expect { subject }.not_to raise_error
    end
  end

  context "given a configuration with an invalied database_pool" do
    context "given no ENV[\"DATABASE_POOL\"]" do
      let(:database_pool) { nil }

      it "logs a message with a warn severity" do
        expect(logger).to receive(:warn).with("[PRY-BYETYPO] ENV[\"DATABASE_POOL\"] is empty. Please assign a value to it to enable the functionality of pry-byetypo.")

        subject
      end
    end

    context "given unreadable database_pool value" do
      let(:database_pool) { "<%= Rails.secrets.database_pool %>" }

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("DATABASE_POOL").and_return("mocked_pool_value")
      end

      it "infers the database config pool with the ENV[\"DATABASE_POOL\"] value" do
        subject
        expect(database_config["pool"]).to eq("mocked_pool_value")
      end
    end
  end
end
