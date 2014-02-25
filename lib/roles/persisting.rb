require 'roles/role'
require 'persisters/persister'

# Role for adding persistability to model objects.
class Persisting < Role
  attr_accessor :id

  # Saves the decorated object with the appropriate persister.
  def save(id=nil)
    saved = Persister.for(@decorated.class).save(@decorated, id)

    if saved
      self.id = saved.keys.first
      self
    end
  end

  # Loads persisted data into the decorated object
  def load(id)
    loaded = Persister.for(@decorated.class).load(id)

    @id = loaded.keys.first
    @decorated.update(loaded[@id].to_hash)

    self
  end

  # Removes the decorated object from the appropriate persister.
  def delete(id)
    Persister.for(@decorated.class).delete(id)
  end

  def ==(other)
    super && other.id == @id
  end

  def where(params)
    Persister.for(@decorated).where(params)
  end
end