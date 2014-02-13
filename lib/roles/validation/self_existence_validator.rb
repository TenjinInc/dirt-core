# Tests for the existence of the given id in the persister.
#
# For more about validation, see Validating
class SelfExistenceValidator
  def initialize(type, id)
    @type = type
    @id = id
  end

  # +true+ if the validated object exists in the persister.
  def valid?(validated)
    Persister.for(@type).exists?(@id)
  end

  def error_message(validated)
    "That #{@type.to_s.demodulize.downcase} (id: #{ @id || "nil" }) does not exist."
  end
end