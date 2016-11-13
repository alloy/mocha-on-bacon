require 'mocha/api'

module Bacon
  module MochaRequirementsCounter
    def self.increment
      Counter[:requirements] += 1
    end
  end

  class Context
    include Mocha::API
  end

  # For now let's assume only MacBacon has this class and upstream Bacon
  # won't have it any time soon.
  if defined?(Bacon::Specification)
    class Specification
      include Mocha::API

      alias_method :run_before_mocha, :run
      def run
        @context.mocha_setup
        run_before_mocha
      end

      alias_method :execute_block_before_mocha, :execute_block
      def execute_block
        execute_block_before_mocha do
          begin
            yield
          rescue Mocha::ExpectationError => e
            raise Error.new(:failed, e.message).tap {|ne| ne.set_backtrace(e.backtrace) }
          end
        end
      end

      alias_method :finalize_before_mocha, :finalize
      def finalize
        # If an exception already occurred, we don't need to verify Mocha
        # expectations anymore, as the test has already failed.
        unless @exception_occurred
          execute_block { @context.mocha_verify(MochaRequirementsCounter) }
        end
        @context.mocha_teardown
        finalize_before_mocha
      end
    end

  else

    class Context
      alias_method :it_before_mocha, :it
      def it(description, &block)
        it_before_mocha(description) do
          begin
            mocha_setup
            block.call
            mocha_verify(MochaRequirementsCounter)
          rescue Mocha::ExpectationError => e
            raise Error.new(:failed, e.message).tap {|ne| ne.set_backtrace(e.backtrace) }
          ensure
            mocha_teardown
          end
        end
      end
    end

  end
end
