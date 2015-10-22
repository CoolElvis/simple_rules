module SimpleRules
  class Rule
    attr_accessor :block, :action, :object_name, :error_message

    def initialize (action, object_name, error_message, &block)
      @action        = action
      @object_name  = object_name
      @block         = block
      @error_message = error_message

      raise ArgumentError, 'Block is not given' unless block
    end
  end

  class SimpleRulesError < StandardError; end

  class RuleNotFindError < SimpleRulesError; end

  class NotAuthorized < SimpleRulesError; end

end
