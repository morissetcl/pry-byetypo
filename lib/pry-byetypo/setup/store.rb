module Setup
  module Store
    DEFAULT_STORE_PATH = "byetypo_dictionary.pstore"

    def store
      @store ||= PStore.new(store_path)
    end

    def store_path
      ENV["BYETYPO_STORE_PATH"] || DEFAULT_STORE_PATH
    end
  end
end
