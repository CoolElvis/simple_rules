require 'simple_rules/version'
require 'simple_rules/rule'
require 'simple_rules/configuration'

module SimpleRules
  #TODO refact Configuration.options
  extend Configuration

  @rules = []

  class << self
    attr_accessor :rules

    # @param action
    # @param object [Class, Instance]
    # @param subject [User, AnySubject]
    # @raise NotAuthorized
    # @example SimpleRules.can? :some_action, some_object, subject
    def can?(action, object, subject)
      if object.class == Class
        klass = object.to_s.split(':').last
      else
        klass = object.class.to_s.split(':').last
      end

      rule = self.get_rule(action, klass)

      if rule.block.call(object, subject)
        true
      else
        # TODO Configuration.options.raise_not_authorized?
        if raise_not_authorized
          raise NotAuthorized, rule.error_message
        else
          false
        end
      end
    end

    # @param action
    # @param object [Class, Instance]
    # @param error_message [String]
    # @example
    #   SimpleRules.can :some_action, SomeObject do |object, subject|
    #     subject.some_attr ==  object.some_attr
    #   end
    def can(action, object, error_message: nil, &block)
      SimpleRules.rules << Rule.new(action, object.to_s, error_message: error_message, &block)
    end

    protected

    def get_rule(action, object_name)
      SimpleRules.rules.detect { |rule| (rule.action == action || rule.action == :manage) && rule.object_name == object_name } || raise(RuleNotFindError, 'Rule not found')
    end

  end

end
