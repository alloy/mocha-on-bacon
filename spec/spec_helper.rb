require "rubygems" rescue LoadError
require "bacon"
require "mocha"

require File.expand_path('../../lib/mocha-on-bacon', __FILE__)

class Should
  alias_method :have, :be
end

module MochaBaconHelper
  module SilenceOutput
    attr_accessor :silence
    
    def handle_specification(name)
      puts name unless silence
      yield
      puts unless silence
    end
    
    def handle_requirement(description)
      print "- #{description}" unless silence
      error = yield
      puts(error.empty? ? "" : " [#{error}]") unless silence
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
    @mocha_context ||= Bacon::Context.new("Mocha test context")
  end
  
  def run_example(proc)
    @example_counter ||= 0; @example_counter += 1
    
    counter_before = counter.dup
    error_log_before = error_log.dup
    Bacon.silence = true
    
    mocha_context.it("Mocha example `#{@example_counter}'", &proc)
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