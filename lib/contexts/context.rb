module Dirt
  class Context
    def self.run(*args)
      new(*args).call()
    end

    # Override and save state here.
    def initialize(args)
    end

    # Override to perform the actual command
    def call
    end
  end
end