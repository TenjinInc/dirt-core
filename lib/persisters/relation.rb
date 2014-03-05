require 'persisters/memory_persister'

class Relation < MemoryPersister
  @records = {}

  def initialize(records)
    @records = records
  end

  def first
    match = @records.first
    match ? MemoryRecord.new(match.last.to_hash.merge(id: match.first)) : nil
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