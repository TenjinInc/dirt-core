# An in-memory implementation of persistence.
class MemoryPersister
  def initialize
    @next_id = 0
    @records = {}
  end

  # Saves the record to the array either under the given id, or a new one if none is provided,
  def save(data, id)
    id ||= @next_id += 1

    @records[id] = data

    @records.slice(id)
  end

  # Returns the record with the given id.
  def load(id)
    raise MissingRecordError.new(id) unless exists?(id)

    @records.slice(id)
  end

  # Returns the list of all records.
  def all
    @records.dup
  end

  # Removes the record with the given id.
  def delete(id)
    raise MissingRecordError.new(id) unless exists?(id)

    {id => @records.delete(id)}
  end

  # determines whether a record exists with the given id
  def exists?(id)
    @records[id] != nil
  end
end

class MissingRecordError < StandardError
  def initialize(id)
    super("No record can be found for id #{id || 'nil'}.")
  end
end