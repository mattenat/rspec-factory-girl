module Spec
  module FactoryGirl
    module Matchers
      class BeBuildedByFactory
        def initialize(factory)
          @factory = factory
          @errors = []
        end

        def description
          "build instance of '#{@target}' by factory '#{@factory}'"
        end

        def matches?(target)
          @target = target_class(target)
          @factory ||= default_factory
          
          begin
            @result = Factory.build(@factory)
          rescue ActiveRecord::RecordInvalid => e
            @errors << e.to_s
            return false
          end

          unless @result.kind_of?(@target)
            @errors << "Not a kind of #{@target}"
          end

          unless @result.valid?
            @errors += @result.errors.full_messages
          end

          @errors.empty?
        end

        def failure_message
          "expected #{@target.inspect} to be build by factory '#{@factory}'"
        end

        def negative_failure_message
          "expected #{@target.inspect} not to be build by factory '#{@factory}'"
        end

        private

        def default_factory
          @target.to_s.underscore.to_sym if @target.kind_of? Class
        end

        def target_class(target)
          target.kind_of?(Class) ? target : target.class
        end
      end

      def be_builded_by_factory(factory = nil)
        BeBuildedByFactory.new(factory)
      end
    end
  end
end