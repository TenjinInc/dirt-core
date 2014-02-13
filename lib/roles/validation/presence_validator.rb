# Tests whether the given property is set (ie non-nil)
#
# For more about validation, see Validating
class PresenceValidator
  # Takes the property name as symbol
  def initialize(property)
    @property = property
  end

  def valid?(validated)
    return false unless validated

    value = validated.send(@property)

    value.present? && value !~ /^\s*$/
  end

  def error_message(validated)
    "#{validated.class.to_s.demodulize} #{@property} must be provided."
  end
end