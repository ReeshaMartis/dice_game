class InMemoryStore
  @store = {}

  def self.set(key, value)
    @store[key] = value
  end

  def self.get(key)
    @store[key]
  end

  def self.delete(key)
    @store.delete(key)
  end
end
