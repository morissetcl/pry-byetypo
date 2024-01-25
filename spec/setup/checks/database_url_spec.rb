# frozen_string_literal: true

require "logger"

RSpec.describe Setup::Checks::DatabaseUrl do
  subject { described_class.check(database_config, logger) }

  let(:database_url) { "database_url" }
  let(:database_config) { {"adapter" => "postgresql", "encoding" => "unicode", "pool" => "25", "url" => database_url} }
  let(:logger) { Logger.new($stdout) }

  context "given a configuration with a valied database_url" do
    it "does not raise error" do
      expect { subject }.not_to raise_error
    end
  end

  context "given a configuration with an invalied database_url" do
    context "given no ENV[\"DATABASE_URL\"]" do
      let(:database_url) { nil }

      it "logs a message with a warn severity" do
        expect(logger).to receive(:warn).with("[PRY-CYRANO] ENV[\"DATABASE_URL\"] is empty. Please assign a value to it to enable the functionality of pry-cyrano.")

        subject
      end
    end

    context "given an unreadable database_url value" do
      let(:database_url) { "<%= Rails.secrets.database_url %>" }

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("DATABASE_URL").and_return("mocked_url_value")
      end

      it "infers the database config URL with the ENV[\"DATABASE_URL\"] value" do
        subject
        expect(database_config["url"]).to eq("mocked_url_value")
      end
    end
  end
end
