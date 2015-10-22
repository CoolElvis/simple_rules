module SimpleRules
  module Configuration

    # Available options.
    OPTION_NAMES = [
        :raise_not_authorized
    ]

    attr_accessor *OPTION_NAMES

    # A global configuration set via the block.
    # @example
    #   SimpleRules.configure do |config|
    #     config.raise_not_authorized = true
    #   end
    def configure
      yield self if block_given?
      self
    end

  end
end
