require 'spec_helper'

describe SimpleRules do

  context 'when SimpleRule module is included' do
    before :all do
      class App
        include SimpleRules
      end
    end

    it 'respond to #can method' do
      expect(App.respond_to? :can).to eq true
    end

    it 'respond to #can? method' do
      expect(App.respond_to? :can?).to eq true
    end

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
        App.can :some_action, 'TrueModel' do |model_instance, user|
          # Defining conditions when 'user' can do ':some_action' on 'TrueModel'
          model_instance.some_attr == user.some_attr
        end

        App.can :some_action, 'FalseModel' do |model_instance, user|
          model_instance.some_attr == user.some_attr
        end

      end

      it 'TrueUser can :some_action on SomeModel' do
        expect(App.can? :some_action, TrueModel.new, TrueUser.new).to eq true
      end

      it 'FalseUser can not :some_action on SomeModel' do
        expect(App.can? :some_action, TrueModel.new, FalseUser.new).to eq false
      end

      it 'TrueUser can not :some_action on FalseModel' do
        expect(App.can? :some_action, FalseModel.new, TrueUser.new).to eq false
      end

      it 'manager can do any action on given object' do
        user = Object.new

        def user.manager?
          true
        end

        App.can :manage, 'Object' do |object_instance, user|
          user.manager?
        end

        expect(App.can? :some_action, Object.new, user).to eq true
      end

      context 'when rule not find' do
        it 'throw RuleNotFindError exception' do
          expect { App.can? :fake_action, FalseModel.new, FalseUser.new }.to raise_exception(SimpleRules::RuleNotFindError)
        end
      end

      context 'when define rules in App scope' do
        class App
          include SimpleRules

          can :some_action, 'Object' do |object, user|
            true
          end

        end

        it 'respond to #can method' do
          expect(App.respond_to? :can).to eq true
        end

        it 'respond to #can? method' do
          expect(App.respond_to? :can?).to eq true
        end

        it 'rule is working' do
          expect(App.can? :some_action, Object, Object.new).to eq true
        end

      end

    end
  end

end
