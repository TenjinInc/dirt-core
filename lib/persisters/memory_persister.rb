module Dirt
  require 'errors/missing_record_error'
  require 'ostruct'

  # An in-memory implementation of persistence.
  class MemoryPersister
    def initialize(&block)
      @next_id = 0
      @records = {}
      @new_maker = block
    end

    def new(*args)
      #MemoryRecord.new(*args)
      @new_maker.yield(*args)
    end

    # Saves the record to the array either under the given id, or a new one if none is provided,
    def save(data, id=nil)
      assert_exists(id)

      id ||= @next_id += 1

      @records[id] = data

      MemoryRecord.new(data.to_hash.merge(id: id))
    end

    # Returns the record with the given id.
    def load(id)
      assert_exists(id)

      record = @records[id]

      record ? MemoryRecord.new(record.to_hash.merge(id: id)) : nil
    end

    # Returns the list of all records.
    def all
      @records.collect do |id, r|
        MemoryRecord.new(r.to_hash.merge(id: id))
      end
    end

    # Removes the record with the given id.
    def delete(id)
      if @records.has_key?(id)
        MemoryRecord.new(@records.delete(id).to_hash.merge(id: id))
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
      end.collect do |id, record|
        MemoryRecord.new(record.to_hash.merge(id: id))
      end

      Relation.new(matches)
    end

    private
    def assert_exists(id)
      raise MissingRecordError.new("There is no record by id #{id}.") if id && !@records[id]
    end
  end

  class MemoryRecord < OpenStruct
    alias_method :to_hash, :marshal_dump
  end

# This must be at the bottom to work around the circular dependency with Relation.
  require 'persisters/relation'
end