# frozen_string_literal: true

require_relative "../checks/database_url"
require_relative "../checks/database_pool"
require_relative "../store"
require_relative "../database"

require "pstore"

module Setup
  module Dictionary
    class ActiveRecord
      class << self
        include Store

        def initialize!
          establish_db_connection
          populate_store
        end

        private

        def populate_store
          store.transaction do
            store.commit unless staled_store?

            store["active_record_models"] = populate_active_record_models_dictionary
            store["associations"] = populate_associations
            store["synced_at"] = Time.now
          end
        end

        def establish_db_connection
          ::ActiveRecord::Base.establish_connection(Setup::Database.config)
        end

        def populate_active_record_models_dictionary
          Zeitwerk::Loader.eager_load_all
          ::ActiveRecord::Base.descendants.map { |model| format_active_record_model(model) }.flatten
        end

        def populate_associations
          table_names = ::ActiveRecord::Base.connection.tables
          singularize_table_names = table_names.map { |a| a.chop }
          table_names.zip(singularize_table_names).flatten
        end

        # This method takes an ActiveRecord model as an argument and formats its name and module information.
        # If the model is within a module namespace, it returns an array containing the model's name and an array of its modules.
        # If the model is not within a module, it returns just the model's name as a string.
        def format_active_record_model(model)
          modules = model.name.split("::")
          return model.name, modules if modules.count > 1

          model.name
        end
      end
    end
  end
end
