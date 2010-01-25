require "bacon"
require "mocha"

module Bacon
  module MochaRequirementsCounter
    def self.increment
      Counter[:requirements] += 1
    end
  end
  
  class Context
    include Mocha::API
    
    alias_method :it_before_mocha, :it
    
    def it(description, &block)
      it_before_mocha(description) do
        begin
          mocha_setup
          block.call
          mocha_verify(MochaRequirementsCounter)
        rescue Mocha::ExpectationError => e
          raise Error.new(:failed, e.message)
        ensure
          mocha_teardown
        end
      end
    end
  end
end