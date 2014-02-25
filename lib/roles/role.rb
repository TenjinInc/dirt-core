# Roles are part of the DCI system design paradigm. They decorate a model object to extend its
# behaviour for the context of a single interaction.
class Role
  # Takes the decorated object.
  def initialize(decorated)
    @decorated = decorated
  end

  # Attempts to run the missing method on the decorated object before exploding as normal,
  # with a light tingling sensation.
  def method_missing(method, *args, &block)
    if @decorated.respond_to?(method)
      @decorated.send(method, *args, &block)
    else
      super
    end
  end

  def class
    @decorated.class
  end

  def respond_to?(method, privates = false)
    super || @decorated.respond_to?(method, privates)
  end

  def ==(other)
    other && (other.instance_variable_get(:@decorated) == @decorated || other == @decorated)
  end
end