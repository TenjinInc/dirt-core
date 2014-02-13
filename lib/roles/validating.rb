# A Role for testing whether the wrapped object is valid, using the list of validators provided in the constructor,
#
# == Validators
# Each validator must respond to
# * +valid?+        to return whether that validator passes, and
# * +error_message+ to return any errors found when +valid?+ is +false+.
class Validating < Role
  # Takes the decorated object and then the list of validators. See Role for more on decoration.
  def initialize(decorated, validators)
    super(decorated)
    @validators = validators
  end

  # Returns +true+ _iff_ every validator passes.
  def valid?
    @validators.all? do |v|
      v.valid?(@decorated)
    end
  end

  # Returns a list of the string messages returned from the validators that have failed.
  def errors
    @validators.collect do |v|
      v.error_message(@decorated) unless v.valid?(@decorated)
    end.reject { |m| m.nil? }
  end
end