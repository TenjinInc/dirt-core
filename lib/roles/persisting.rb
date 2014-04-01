require 'roles/role'
require 'persisters/persister'

# Role for adding persistability to model objects.
class Persisting < Dirt::Role
  attr_reader :id

  def initialize(decorated, id=nil)
    super(decorated)
    @id = id
  end

  # Saves the decorated object with the appropriate persister.
  def save()
    saved = persister.save(@decorated, @id)

    if saved
      @id = saved.id
      self
    end
  end

  # Loads persisted data into the decorated object
  def load(id)
    assert_exists(id)

    loaded = persister.load(id)

    chameleonize(loaded)

    self
  end

  # Loads from the first record that matches the given attributes.
  def load_by(attrs)
    record = Persister.for(@decorated.class).find(attrs)

    unless record
      raise Dirt::MissingRecordError.new("No record matches #{attrs.collect { |pair| pair.join(' == ') }.join(', ')}.")
    end

    chameleonize(record)

    self
  end

  # Removes the decorated object from the appropriate persister.
  def delete(id)
    assert_exists(id)

    persister.delete(id)
  end

  def ==(other)
    super && other.id == @id
  end

  private
  def chameleonize(record)
    @id = record.id
    @decorated.update(record.to_hash.except(:id))
  end

  def persister
    Persister.for(@decorated.class)
  end

  def assert_exists(id)
    unless persister.exists?(id)
      raise Dirt::MissingRecordError.new("That #{@decorated.class.to_s.demodulize.downcase} (id: #{id || 'nil'}) does not exist.")
    end
  end
end