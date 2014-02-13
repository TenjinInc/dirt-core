require 'active_support/all'

# This Persister registry is the source for all persisters in the system. Register persisters here with
# #for.
#
# == Persisters
# All persisters must respond to the following:
#
# * +all+            Returns all records.
# * +find(id)+       Returns the record with the given id.
# * +exists?(id)+    Determines whether a record exists with the given id
# * +save(data)+     Saves a new record.
# * +save(data, id)+ Saves a record at the given id.
# * delete(id)       Deletes the record with the given id.
class Persister
  # If persister is supplied, then this sets the persister for the given class,
  # otherwise it returns the previously set persister for that class.
  # If the first argument is a class, it is converted to a symbol.
  def self.for(klass, persister=nil)
    if klass.is_a? Class
      klass = klass.to_s.demodulize.underscore.to_sym
    end

    @@persisters ||= {}
    @@persisters[klass] ||= persister if persister

    @@persisters[klass]
  end

  # Forgets about all previously saved persisters.
  def self.clear
    @@persisters = nil
  end
end