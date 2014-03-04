require 'errors/missing_record_error'
require 'ostruct'

# An in-memory implementation of persistence.
class MemoryPersister
  def initialize
    @next_id = 0
    @records = {}
  end

  # Saves the record to the array either under the given id, or a new one if none is provided,
  def save(data, id=nil)
    id ||= @next_id += 1

    @records[id] = data

    OpenStruct.new(id: id, data: @records[id])
  end

  # Returns the record with the given id.
  def load(id)
    loaded = @records[id]

    loaded ? OpenStruct.new(id: id, data: loaded) : nil
  end

  # Returns the list of all records.
  def all
    @records.collect do |id, r|
      OpenStruct.new(id: id, data: r)
    end
  end

  # Removes the record with the given id.
  def delete(id)
    if @records.has_key?(id)
      OpenStruct.new(id: id, data: @records.delete(id))
    end
  end

  # determines whether a record exists with the given id
  def exists?(id)
    @records[id] != nil
  end

  def find(params)
    where(params).first
  end

  def where(params)
    matches = @records.select do |id, record|
      same_id = (params.delete(:id) || id) == id

      params.all? { |attr, val| record.send(attr) == val } && same_id
    end

    Relation.new(matches)
  end
end

# This must be at the bottom to work around the circular dependency with Relation.
require 'persisters/relation'