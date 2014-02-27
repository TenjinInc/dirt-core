require 'roles/role'
require 'persisters/persister'

# Role for adding persistability to model objects.
class Persisting < Role
  attr_reader :id

  def initialize(decorated, id=nil)
    super(decorated)
    @id = id
  end

  # Saves the decorated object with the appropriate persister.
  def save(id=nil)
    saved = persister.save(@decorated, id)

    if saved
      @id = saved.keys.first
      self
    end
  end

  # Loads persisted data into the decorated object
  def load(id)
    assert_exists(id)

    loaded = persister.load(id)

    chameleonize(loaded.keys.first, loaded[id])

    self
  end

  # Loads from the first record that matches the given attributes.
  def load_by(attrs)
    records = Persister.for(@decorated.class).where(attrs)

    if records.empty?
      raise MissingRecordError.new("No record matches #{attrs.collect { |pair| pair.join(' == ') }.join(', ')}.")
    end

    chameleonize(records.first.first, records.first.last)

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
  def chameleonize(id, record)
    @id = id
    @decorated.update(record.to_hash)
  end

  def persister
    Persister.for(@decorated.class)
  end

  def assert_exists(id)
    raise MissingRecordError.new("That #{@decorated.class.to_s.demodulize.downcase} (id: #{id || 'nil'}) does not exist.") unless persister.exists?(id)
  end
end