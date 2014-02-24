require 'roles/role'
require 'persisters/persister'

# Role for adding persistability to model objects.
class Persisting < Role
  attr_accessor :id

  # Saves the decorated object with the appropriate persister.
  def save(id=nil)
    saved = Persister.for(@decorated.class).save(@decorated, id)

    if saved
      self.id = saved.id
      self
    end
  end

  # Retrieves the decorated object from the appropriate persister.
  def load(id)
    Persister.for(@decorated).load(id)
  end

  # Removes the decorated object from the appropriate persister.
  def delete(id)
    Persister.for(@decorated).delete(id)
  end

  def ==(other)
    other && other.instance_variable_get(:@decorated) == @decorated && other.id == @id
  end

  def where(params)
    Persister.for(@decorated).where(params)
  end
end