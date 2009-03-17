# To change this template, choose Tools | Templates
# and open the template in the editor.

module Spec
  module FactoryGirl
    module Matchers
      class Base
        def initialize(factory)
          @factory = factory
          @errors = []
        end

        def matches?(target)
          prepare_matches(target)
          return false unless @result

          # record is a kind of target class
          unless @result.kind_of?(@target)
            @errors << "record isn't a kind of #{@target}"
            return false
          end

          # record is valid
          unless @result.valid?
            @errors += @result.errors.full_messages
            return false
          end

          # A second record can be created
          begin
            @result.save!
            Factory.create(@factory)
          rescue ActiveRecord::RecordInvalid => e
            @errors << "attribute have uniqu validation, use sequence in factory (#{e.to_s})"
            return false
          end

          @errors.empty?
        end

        private

        def prepare_matches(target)
          @target  ||= target_class(target)
          @factory ||= default_factory(@target)
        end

        def default_factory(target)
          target.to_s.underscore.to_sym if target.kind_of? Class
        end

        def target_class(target)
          target.kind_of?(Class) ? target : target.class
        end
      end
    end
  end
end
