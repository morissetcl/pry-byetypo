module Setup
  module Store
    DEFAULT_STORE_PATH = "cyrano_dictionary.pstore"

    def store
      @store ||= PStore.new(store_path)
    end

    def store_path
      ENV["CYRANO_STORE_PATH"] || DEFAULT_STORE_PATH
    end
  end
end
