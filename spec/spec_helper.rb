require "rubygems" rescue LoadError
require File.expand_path('../../lib/mocha-on-bacon', __FILE__)

class Should
  alias_method :have, :be
end

class MochaTestContext < Bacon::Context
  def initialize(name)
    @name = name
    @before, @after = [], []
    @specifications = []
    @current_specification_index = 0
  end

  def it(description, &block)
    super
    @specifications.pop
  end

  def specification_did_finish(spec)
    # We don't care in this case
  end
end

module MochaBaconHelper
  module SilenceOutput
    attr_accessor :silence

    def handle_specification_begin(name)
      puts name unless silence
    end

    def handle_specification_end
      puts unless silence
    end

    def handle_specification(name)
      handle_specification_begin(name)
      yield
      handle_specification_end
    end

    def handle_requirement_begin(description)
      print "- #{description}" unless silence
    end

    def handle_requirement_end(error)
      puts(error.empty? ? "" : " [#{error}]") unless silence
    end

    def handle_requirement(description)
      handle_requirement_begin(description)
      error = yield
      handle_requirement_end(error)
    end
    
    def handle_summary
      print Bacon::ErrorLog if Bacon::Backtraces && !silence
      puts "%d specifications (%d requirements), %d failures, %d errors" %
        Bacon::Counter.values_at(:specifications, :requirements, :failed, :errors) unless silence
    end
  end
  Bacon.extend SilenceOutput
  
  def counter
    Bacon::Counter
  end
  
  def error_log
    Bacon::ErrorLog
  end
  
  def mocha_context
    @mocha_context ||= MochaTestContext.new("Mocha test context") {}
  end
  
  def run_example(proc)
    @example_counter ||= 0; @example_counter += 1
    
    counter_before = counter.dup
    error_log_before = error_log.dup
    Bacon.silence = true
    
    spec = mocha_context.it("Mocha example `#{@example_counter}'", &proc)
    spec.run if spec.respond_to?(:run) # MacBacon
    [{ :failed => counter[:failed] - counter_before[:failed], :errors => counter_before[:errors] - counter_before[:errors] }, error_log.dup]
  ensure
    counter.replace(counter_before)
    error_log.replace(error_log_before)
    Bacon.silence = false
  end
  
  def satisfied
    lambda do |proc|
      difference, _ = run_example(proc)
      difference[:errors] == 0 && difference[:failed] == 0
    end
  end
  
  def unsatisfied(mockee, method, params = 'any_parameters')
    lambda do |proc|
      difference, error_log = run_example(proc)
      difference[:errors] == 0 && difference[:failed] == 1 &&
        error_log.include?("- expected exactly once, not yet invoked: #{mockee.mocha_inspect}.#{method}(#{params})")
    end
  end
  
  def received_unexpected_invocation(mockee, method, params = '')
    lambda do |proc|
      difference, error_log = run_example(proc)
      difference[:errors] == 0 && difference[:failed] == 1 &&
        error_log.include?("unexpected invocation: #{mockee.mocha_inspect}.#{method}(#{params})")
    end
  end
end
