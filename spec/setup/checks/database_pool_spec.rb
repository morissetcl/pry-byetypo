# frozen_string_literal: true

require "logger"

RSpec.describe Setup::Checks::DatabasePool do
  subject { described_class.check }

  let(:database_pool) { "25" }
  let(:database_config) { {"adapter" => "postgresql", "encoding" => "unicode", "pool" => database_pool, "url" => "database_url"} }

  before do
    allow(Setup::Database).to receive(:config).and_return(database_config)
  end

  context "given a configuration with a valid database_pool" do
    it "does not raise error" do
      expect { subject }.not_to raise_error
    end
  end

  context "given a configuration with an invalid database_pool" do
    # context "given no ENV[\"DATABASE_POOL\"]" do
    #   let(:database_pool) { nil }

    #   fit "logs a message with a warn severity" do
    #     allow(Logger).to receive(:new).with($stdout).and_return()
    #     expect(Logger).to receive(:new)
    #     subject
    #   end
    # end

    context "given unreadable database_pool value" do
      let(:database_pool) { "<%= Rails.secrets.database_pool %>" }

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("DATABASE_POOL").and_return("mocked_pool_value")
      end

      it "checks against ENV variable value" do
        # expect(URI).to receive(:parse).with(ENV["DATABASE_POOL"])
        subject
      end
    end
  end
end
