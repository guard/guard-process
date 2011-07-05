require_relative '../test_helper'

class GuardProcessTest < MiniTest::Unit::TestCase
  def setup
    ENV['GUARD_ENV'] = 'test'
    @command = "#{File.expand_path(File.dirname(__FILE__) + '/../run_me.rb')}"
    @name = "RunMe"
    @options = {:command => @command, :name => @name}
  end

  def teardown
    ENV['GUARD_ENV'] = nil
  end
  
  def test_run_all_returns_true
    guard = Guard::Process.new([], @options)
    assert guard.run_all
  end

  def test_run_on_change_does_a_reload
    guard = Guard::Process.new([], @options)
    guard.expects(:reload)
    guard.run_on_change("")
  end

  def test_start_runs_command
    process = mock('process')
    IO.stubs(:popen).returns(process)
    IO.expects(:popen).with(@command)
    Guard::UI.expects(:info).with("Starting process #{@name}")
    Guard::UI.expects(:info).with("Started process #{@name}")
    guard = Guard::Process.new([], @options)
    guard.start
  end
end
