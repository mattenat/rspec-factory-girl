module Spec
  module FactoryGirl
    module Matchers
      class BeCreatedByFactory
        def initialize(factory)
          @factory = factory
          @errors = []
        end

        def description
          "create instance of '#{@target}' by factory '#{@factory}'"
        end

        def matches?(target)
          @target = target
          @factory ||= @target.to_s.underscore.to_sym
          
          begin
            @result = Factory.create(@factory)
          rescue ActiveRecord::RecordInvalid => e
            @errors << e.to_s
            return false
          end

          unless @result.kind_of?(@target)
            @errors << "Not a kind of #{@target}"
          end
          
          @errors.empty?
        end

        def failure_message
          "expected #{@target.inspect} to be created by factory '#{@factory}'\n" + @errors.join("\n")
        end
        
        def negative_failure_message
          "expected #{@target.inspect} not to be created by factory '#{@factory}'"
        end
      end

      def be_created_by_factory(factory = nil)
        BeCreatedByFactory.new(factory)
      end
    end
  end
end