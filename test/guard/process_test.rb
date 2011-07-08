require_relative '../test_helper'

class GuardProcessTest < MiniTest::Unit::TestCase
  def setup
    ENV['GUARD_ENV'] = 'test'
    @command = "#{File.expand_path(File.dirname(__FILE__) + '/../run_me.rb')}"
    @name = "RunMe"
    @options = {:command => @command, :name => @name}
    @guard = Guard::Process.new([], @options)
  end

  def teardown
    @guard.stop if @guard.process_running?
    ENV['GUARD_ENV'] = nil
  end

  def test_run_all_returns_true
    assert @guard.run_all
  end

  def test_run_on_change_does_a_reload
    @guard.expects(:reload)
    @guard.run_on_change("")
  end

  def test_env_is_passed_to_io_popen_if_given
    @options[:env] = {'VAR1' => 'VALUE 1', 'VAR2' => 'VALUE 2'}
    IO.expects(:popen).with([@options[:env], @command]).returns(stub_everything)
    @guard = Guard::Process.new([], @options)
    @guard.start
  end

  def test_start_runs_command_and_stop_stops_it
    Guard::UI.expects(:info).with("Starting process #{@name}")
    Guard::UI.expects(:info).with("Started process #{@name}")
    @guard.start
    assert @guard.process_running?
    Guard::UI.expects(:info).with("Stopping process #{@name}")
    Guard::UI.expects(:info).with("Stopped process #{@name}")
    @guard.stop
    refute @guard.process_running?
  end

  def test_reload_stops_and_starts_command
    @guard.start
    assert @guard.process_running?
    @guard.reload
    assert @guard.process_running?
  end

  def test_commands_are_formatted_correctly_with_and_without_env
    @options = {:command => 'echo test test', :name => 'EchoProcess'}
    @env     = {'VAR3' => 'VALUE 3'}

    IO.expects(:popen).with(["echo", "test", "test"]).returns(stub_everything)
    IO.expects(:popen).with([@env, "echo", "test", "test"]).returns(stub_everything)

    @guard = Guard::Process.new([], @options)
    @guard.start and @guard.stop

    @options[:env] = @env

    @guard = Guard::Process.new([], @options)
    @guard.start and @guard.stop
  end
end
