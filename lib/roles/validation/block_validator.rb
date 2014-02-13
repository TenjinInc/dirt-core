# Takes a block, and uses it to determine validity,
class BlockValidator
  def initialize(block, message_block)
    @block = block
    @message_block = message_block
  end

  def valid?(valdated)
    @block.call
  end

  def error_message(validated)
    @message_block.call
  end
end