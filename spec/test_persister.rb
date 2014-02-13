# An in-memory implementation of persistence.
class TestPersister
  def initialize
    @next_id = 0
    @records = {}
  end

  # Saves the record to the array either under the given id, or a new one if none is provided,
  def save(data, id=nil)
    p = Persisting.new(data)

    id = id || @next_id += 1

    p.id = id ? id : @next_id += 1

    @records[id] = p

    p
  end

  def children_of(record)
    @records.values.select { |r| r.parent_id == record.id }
  end

  # Returns the record with the given id.
  def load(id)
    @records[id]
  end

  # Returns the list of all records.
  def all
    @records.values
  end

  # Removes the record with the given id.
  def delete(id)
    @records ||= []

    @records.delete(id)
  end

  # determines whether a record exists with the given id
  def exists?(id)
    @records[id] != nil
  end
end