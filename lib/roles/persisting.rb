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
    saved = Persister.for(@decorated.class).save(@decorated, id)

    if saved
      @id = saved.keys.first
      self
    end
  end

  # Loads persisted data into the decorated object
  def load(id)
    loaded = Persister.for(@decorated.class).load(id)

    chameleonize(loaded.keys.first, loaded[id])

    self
  end

  # Loads from the first record that matches the given attributes.
  def load_by(attrs)
    record = Persister.for(@decorated.class).where(attrs).first

    chameleonize(record.first, record.last)

    self
  end

  # Removes the decorated object from the appropriate persister.
  def delete(id)
    Persister.for(@decorated.class).delete(id)
  end

  def ==(other)
    super && other.id == @id
  end

  private
  def chameleonize(id, record)
    @id = id
    @decorated.update(record.to_hash)
  end
end