# frozen_string_literal: true
require 'byebug'

class ApplicationDictionary

  def initialize
    establish_db_connection
    populate_active_record_models_dictionary
    populate_associations
  end

  def active_record_models
    @active_record_models
  end

  def associations
    @associations
  end

  private

  def populate_associations
    table_names = ActiveRecord::Base.connection.tables
    singularize_table_names = table_names.map { |a| a.chop }
    @associations = table_names.zip(singularize_table_names).flatten
  end

  def populate_active_record_models_dictionary
    Zeitwerk::Loader.eager_load_all
    @active_record_models = ActiveRecord::Base.descendants.map { |model| model.name }
  end

  def establish_db_connection
    configuration_checks
    ActiveRecord::Base.establish_connection(development_database_config)
  end

  def configuration_checks
    logger = Logger.new(STDOUT)

    begin
      URI.parse(development_database_config["url"])
    rescue URI::InvalidURIError => e
      logger.info("Database URL not readable, try to connect using the ENV[\"DATABASE_URL\"]")
      development_database_config["url"] = ENV["DATABASE_URL"]
    end

    begin
      URI.parse(development_database_config["pool"])
    rescue URI::InvalidURIError => e
      logger.info("Database pool not readable, try to connect using the ENV[\"DATABASE_POOL\"]")
      development_database_config["pool"] = ENV["DATABASE_POOL"]
    end
  end

  def database_config
    YAML.safe_load(File.read("./config/database.yml"), aliases: true)
  end

  def development_database_config
    @development_database_config ||= database_config["development"]
  end
end