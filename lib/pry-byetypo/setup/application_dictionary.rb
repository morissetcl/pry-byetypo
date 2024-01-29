# frozen_string_literal: true

require_relative "checks/database_url"
require_relative "checks/database_pool"
require_relative "store"

require "pstore"

module Setup
  class ApplicationDictionary
    include Store

    def initialize
      establish_db_connection
      populate_store
    end

    private

    SEVEN_DAYS = 604800

    def populate_store
      store.transaction do
        store.abort unless staled_store?

        store["active_record_models"] = populate_active_record_models_dictionary
        store["associations"] = populate_associations
        store["synced_at"] = Time.now
      end
    end

    def establish_db_connection
      configuration_checks
      ActiveRecord::Base.establish_connection(development_database_config)
    end

    def populate_active_record_models_dictionary
      Zeitwerk::Loader.eager_load_all
      ActiveRecord::Base.descendants.map { |model| model.name }
    end

    def populate_associations
      table_names = ActiveRecord::Base.connection.tables
      singularize_table_names = table_names.map { |a| a.chop }
      table_names.zip(singularize_table_names).flatten
    end

    def configuration_checks
      Setup::Checks::DatabaseUrl.check(development_database_config, logger)
      Setup::Checks::DatabasePool.check(development_database_config, logger)
    end

    def database_config
      YAML.safe_load(File.read("./config/database.yml"), aliases: true)
    end

    def development_database_config
      @development_database_config ||= database_config["development"]
    end

    # By default we update the store every week.
    # TODO: Make it configurable
    def staled_store?
      return true if store["synced_at"].nil?

      (store["synced_at"] + SEVEN_DAYS) <= Time.now
    end

    def logger
      @logger = Logger.new($stdout)
    end
  end
end