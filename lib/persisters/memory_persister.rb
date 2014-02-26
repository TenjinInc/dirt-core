require 'errors/missing_record_error'

# An in-memory implementation of persistence.
class MemoryPersister
  def initialize(type)
    @next_id = 0
    @records = {}
    @type_name = type
  end

  # Saves the record to the array either under the given id, or a new one if none is provided,
  def save(data, id=nil)
    id ||= @next_id += 1

    @records[id] = data

    @records.slice(id)
  end

  # Returns the record with the given id.
  def load(id)
    raise MissingRecordError.new(id, @type_name) unless exists?(id)

    @records.slice(id)
  end

  # Returns the list of all records.
  def all
    @records.dup
  end

  # Removes the record with the given id.
  def delete(id)
    raise MissingRecordError.new(id, @type_name) unless exists?(id)

    {id => @records.delete(id)}
  end

  # determines whether a record exists with the given id
  def exists?(id)
    @records[id] != nil
  end
end
