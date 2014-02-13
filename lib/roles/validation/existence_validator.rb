require 'active_support/all'

# Tests for whether the property referenced by an id is saved in the appropriate persister.
#
# For more about validation, see Validating
class ExistenceValidator
  # Takes the symbol name of the property to validate, and an options hash.
  #
  # Options include:
  # * +as+:: The class of the type to search under
  #
  def initialize(property, opts)
    @property = property
    @type = opts[:as]
    @list = opts[:list] || false
    @bad_ids = []
  end

  def valid?(validated)
    return false unless validated

    if @list
      ids = validated.send(@property) || []
    else
      ids = [validated.send(property_id)]
    end

    persister = Persister.for(@type)

    @bad_ids = ids.select do |id|
      not persister.exists?(id)
    end

    @bad_ids.empty?
  end

  def error_message(validated)
    unless @bad_ids.empty?
      if @list
        "Those #{@type.to_s.demodulize.pluralize} (ids: #{@bad_ids.join(", ")}) do not exist."
      else
        id = validated.send(property_id) if validated

        "That #{@type.to_s.demodulize} (id: #{@bad_ids.first || "nil"}) does not exist."
      end
    end
  end

  private
  def property_id
    "#{@property}_id".to_sym
  end
end