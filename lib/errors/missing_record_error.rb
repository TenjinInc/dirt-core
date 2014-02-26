class MissingRecordError < StandardError
  def initialize(id, type)
    super("That #{type} (id: #{id || 'nil'}) does not exist.")
  end
end