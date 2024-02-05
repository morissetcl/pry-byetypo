# frozen_string_literal: true

require_relative "checks/database_url"
require_relative "checks/database_pool"
require_relative "store"
require_relative "../base"

require "pstore"

module Setup
  class ApplicationDictionary < Base
    include Store

    def initialize(binding)
      @binding = binding
    end

    def call
      establish_db_connection
      populate_store
    end

    private

    attr_reader :binding

    SEVEN_DAYS = 604800

    def populate_store
      store.transaction do
        # Create a table with unique instance identifier information to store variables history.
        store[pry_instance_uid] = []
        store.commit unless staled_store?

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
      ActiveRecord::Base.descendants.map { |model| format_active_record_model(model) }.flatten
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
      YAML.safe_load(File.read(database_config_path), aliases: true)
    end

    def development_database_config
      @development_database_config ||= database_config["development"]
    end

    # This method takes an ActiveRecord model as an argument and formats its name and module information.
    # If the model is within a module namespace, it returns an array containing the model's name and an array of its modules.
    # If the model is not within a module, it returns just the model's name as a string.
    def format_active_record_model(model)
      modules = model.name.split("::")
      return model.name, modules if modules.count > 1

      model.name
    end

    # By default we update the store every week.
    # TODO: Make it configurable
    def staled_store?
      return true if store["synced_at"].nil?

      (store["synced_at"] + SEVEN_DAYS) <= Time.now
    end

    # Use the binding identifier as pry instance uid.
    def pry_instance_uid
      binding.to_s
    end

    def logger
      @logger = Logger.new($stdout)
    end

    def database_config_path
      ENV["DB_CONFIG_PATH"] || "./config/database.yml"
    end
  end
end
