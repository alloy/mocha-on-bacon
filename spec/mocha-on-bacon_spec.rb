require File.expand_path('../spec_helper', __FILE__)

describe "Bacon specs using Mocha, with a mock" do
  extend MochaBaconHelper
  
  it "passes when all expectations were fulfilled" do
    mockee = mock()
    lambda do
      mockee.expects(:blah)
      mockee.blah
    end.should.be satisfied
  end
  
  it "fails when not all expectations were fulfilled" do
    mockee = mock()
    lambda { mockee.expects(:blah) }.should.be unsatisfied(mockee, :blah)
  end
  
  it "fails when there is an unexpected invocation" do
    mockee = mock()
    lambda { mockee.blah }.should.have received_unexpected_invocation(mockee, :blah)
  end
  
  it "passes when the mockee receives all expected parameters" do
    mockee = mock()
    lambda do
      mockee.expects(:blah).with(:wibble => 1)
      mockee.blah(:wibble => 1)
    end.should.be satisfied
  end
  
  it "fails when the mockee receives unexpected parameters and complains about not being satisfied" do
    mockee = mock()
    lambda do
      mockee.expects(:blah).with(:wobble => 1)
      mockee.blah(:wobble => 2)
    end.should.be unsatisfied(mockee, :blah, ':wobble => 1')
  end
  
  it "fails when the mockee receives unexpected parameters and complains about the unexpected parameters" do
    mockee = mock()
    lambda do
      mockee.expects(:blah).with(:wabble => 1)
      mockee.blah(:wabble => 2)
    end.should.have received_unexpected_invocation(mockee, :blah, ':wabble => 2')
  end
end

class AStub
  def blah
  end
end

describe "Bacon specs using Mocha, with a stub" do
  extend MochaBaconHelper
  
  it "passes when all Stubba expectations are fulfilled" do
    stubbee = AStub.new
    lambda do
      stubbee.expects(:blah)
      stubbee.blah
    end.should.be satisfied
  end
  
  it "fails when not all Stubba expectations were fulfilled" do
    stubbee = AStub.new
    lambda { stubbee.expects(:blah) }.should.be unsatisfied(stubbee, :blah)
  end
end
