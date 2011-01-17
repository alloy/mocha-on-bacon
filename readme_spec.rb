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
