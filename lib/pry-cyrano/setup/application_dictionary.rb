# frozen_string_literal: true

require_relative "checks/database_url"
require_relative "checks/database_pool"

module Setup
  class ApplicationDictionary
    def initialize
      establish_db_connection
      populate_active_record_models_dictionary
      populate_associations
    end

    attr_reader :active_record_models

    attr_reader :associations

    private

    def establish_db_connection
      configuration_checks
      ActiveRecord::Base.establish_connection(development_database_config)
    end

    def populate_active_record_models_dictionary
      Zeitwerk::Loader.eager_load_all
      @active_record_models = ActiveRecord::Base.descendants.map { |model| model.name }
    end

    def populate_associations
      table_names = ActiveRecord::Base.connection.tables
      singularize_table_names = table_names.map { |a| a.chop }
      @associations = table_names.zip(singularize_table_names).flatten
    end

    def configuration_checks
      Setup::Checks::DatabaseUrl.check(development_database_config, logger)
      Setup::Checks::DatabasePool.check(development_database_config, logger)
    end

    def logger
      @logger = Logger.new($stdout)
    end

    def database_config
      YAML.safe_load(File.read("./config/database.yml"), aliases: true)
    end

    def development_database_config
      @development_database_config ||= database_config["development"]
    end
  end
end
