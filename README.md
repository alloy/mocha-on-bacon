Mocha on Bacon
==============

_Doesn’t that sound yummy?_

[Mocha][1] is a mocking and stubbing library for Ruby and [Bacon][2] is a small
RSpec clone.

Out of the box, Mocha only ships with adapters for the testing libraries that
come with the Ruby ‘standard library’, which are `Test::Unit` and `MiniTest`.

This is an adapter to make it play nicely with Bacon and its MacRuby specific
fork [MacBacon][3].


Installation
------------

    $ sudo gem install mocha-on-bacon


Usage
-----

    $ cat readme_spec.rb
    require "mocha-on-bacon" # automatically requires mocha

    describe "A mock" do
      before do
        @mock = mock("A mock")
        @mock.expects(:here_you_go).with("a method call!")
      end

      it "passes if an expectation is fulfilled" do
        @mock.here_you_go("a method call!")
      end

      it "fails if an expectation is not fulfilled" do
        # not much happening here
      end
    end

Running it results in:

    $ bacon readme_spec.rb
    A mock
    - passes if an expectation is fulfilled
    - fails if an expectation is not fulfilled [FAILED]

    Bacon::Error: not all expectations were satisfied
    unsatisfied expectations:
    - expected exactly once, not yet invoked: #<Mock:A mock>.here_you_go('a method call!')

      ./lib/mocha-on-bacon.rb:60:in `it': A mock - fails if an expectation is not fulfilled
      ./lib/mocha-on-bacon.rb:54:in `it'
      ./readme_spec.rb:13
      ./readme_spec.rb:3

    2 specifications (2 requirements), 1 failures, 0 errors

For more information see the Mocha and Bacon websites.


License
-------

Copyright (C) 2011-2012, Eloy Durán <eloy.de.enige@gmail.com>

Mocha-on-Bacon is available under the MIT license. See the LICENSE file or
http://www.opensource.org/licenses/mit-license.php


[1]: https://github.com/floehopper/mocha
[2]: https://github.com/chneukirchen/bacon
[3]: https://github.com/alloy/MacBacon
