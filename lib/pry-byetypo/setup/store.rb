module Setup
  module Store
    DEFAULT_STORE_PATH = "byetypo_dictionary.pstore"
    SEVEN_DAYS = 604800

    def store
      @store ||= PStore.new(store_path)
    end

    def store_path
      ENV["BYETYPO_STORE_PATH"] || DEFAULT_STORE_PATH
    end

    # By default we update the store every week.
    # TODO: Make it configurable
    def staled_store?
      return true if store["synced_at"].nil?

      (store["synced_at"] + SEVEN_DAYS) <= Time.now
    end
  end
end
