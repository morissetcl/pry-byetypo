module Setup
  class Database
    class << self
      def config
        database_config["development"]
      end

      private

      def database_config
        erb_content = ERB.new(File.read(database_config_path)).result
        YAML.safe_load(erb_content, aliases: true)
      end

      def database_config_path
        ENV["DB_CONFIG_PATH"] || "./config/database.yml"
      end
    end
  end
end
