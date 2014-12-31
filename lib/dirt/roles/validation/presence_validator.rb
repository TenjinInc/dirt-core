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

    value.present? && !(value =~ /\A\s*\Z/)
  end

  def error_message(validated)
    "#{validated.class.to_s.demodulize} #{@property.to_s.gsub('_', ' ').downcase} must be provided."
  end
end