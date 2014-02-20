# Takes a block, and uses it to determine validity,
class ClosureValidator
  def initialize(block, message_block)
    @block = block
    @message_block = message_block
  end

  def valid?(validated)
    @block.call(validated)
  end

  def error_message(validated)
    @message_block.call(validated)
  end
end