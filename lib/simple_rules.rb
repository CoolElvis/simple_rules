require 'simple_rules/version'
require 'simple_rules/rule'

module SimpleRules

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    @@simple_rules = Array.new

    # @param action
    # @param object [Class, Instance]
    # @param subject [User, AnySubject]
    def can?(action, object, subject)
      if object.class == Class
        klass = object.to_s.split(':').last
      else
        klass = object.class.to_s.split(':').last
      end

      self.get_rule(action, klass).block.call object, subject
    end


    def can(action, object, error_message: nil, &block)
      @@simple_rules << Rule.new(action, object.to_s, error_message: error_message, &block)
    end

    protected

    def get_rule(action, object_name)
      @@simple_rules.detect { |rule| (rule.action == action || rule.action == :manage) && rule.object_name == object_name } || raise(RuleNotFindError, 'Rule not found')
    end

  end

end
