require_relative '../test_helper'

class GuardProcessTest < MiniTest::Unit::TestCase
  def setup
    @guard = Guard::Process.new
  end
  
  def test_the_truth
    assert true
  end
end
