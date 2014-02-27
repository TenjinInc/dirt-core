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
    raise MissingRecordError.new("That #{@type_name} (id: #{id || 'nil'}) does not exist.") unless exists?(id)

    @records.slice(id)
  end

  # Returns the list of all records.
  def all
    @records.dup
  end

  # Removes the record with the given id.
  def delete(id)
    raise MissingRecordError.new("That #{@type_name} (id: #{id || 'nil'}) does not exist.") unless exists?(id)

    {id => @records.delete(id)}
  end

  # determines whether a record exists with the given id
  def exists?(id)
    @records[id] != nil
  end

  def where(params)
    matches = @records.select do |id, record|
      same_id = (params.delete(:id) || id) == id

      params.all? { |attr, val| record.send(attr) == val } && same_id
    end

    if matches.empty?
      raise MissingRecordError.new("No record matches #{params.collect { |pair| pair.join(' == ') }.join(', ')}.")
    end

    Relation.new(matches)
  end

  class Relation < MemoryPersister
    @records = {}

    def initialize(records)
      @records = records
    end

    def first
      @records.first
    end

    def last
      @records.last
    end

    def collect(&block)
      @records.collect(&block)
    end

    def each(&block)
      @records.each(&block)
    end

    def empty?
      @records.empty?
    end
  end
end
