require 'spec_helper'

describe SimpleRules do

  context 'when rule is defined' do
    before :all do

      class TrueModel
        def some_attr
          true
        end
      end

      class FalseModel
        def some_attr
          false
        end
      end

      class TrueUser
        def some_attr
          true
        end
      end

      class FalseUser
        def some_attr
          false
        end
      end

      # Defining rule
      SimpleRules.can :some_action, 'TrueModel' do |model_instance, user|
        # Defining conditions when 'user' can do ':some_action' on 'TrueModel'
        model_instance.some_attr == user.some_attr
      end

      SimpleRules.can :some_action, 'FalseModel' do |model_instance, user|
        model_instance.some_attr == user.some_attr
      end

    end

    it 'TrueUser can :some_action on SomeModel' do
      expect(SimpleRules.can? :some_action, TrueModel.new, TrueUser.new).to eq true
    end

    it 'FalseUser can not :some_action on SomeModel' do
      expect(SimpleRules.can? :some_action, TrueModel.new, FalseUser.new).to eq false
    end

    it 'TrueUser can not :some_action on FalseModel' do
      expect(SimpleRules.can? :some_action, FalseModel.new, TrueUser.new).to eq false
    end

    it 'manager can do any action on given object' do
      user = Object.new

      def user.manager?
        true
      end

      SimpleRules.can :manage, 'Object' do |object_instance, user|
        user.manager?
      end

      expect(SimpleRules.can? :some_action, Object.new, user).to eq true
    end

    context 'when rule not find' do
      it 'throw RuleNotFindError exception' do
        expect { SimpleRules.can? :fake_action, FalseModel.new, FalseUser.new }.to raise_exception(SimpleRules::RuleNotFindError)
      end
    end

    context 'when raise_not_authorized: true' do
      before :all do
        SimpleRules.configure do |config|
          config.raise_not_authorized = true
        end
      end

      it 'raise NotAuthorized' do
        expect { SimpleRules.can? :some_action, TrueModel.new, FalseUser.new }.to raise_exception(SimpleRules::NotAuthorized)
      end
    end

  end
end
