require 'guard'
require 'guard/guard'

module Guard
  class Process < Guard
    def initialize(watchers = [], options = {})
      @process = nil
      @pid = nil
      @command = options.fetch(:command).split
      @env = options[:env]
      @name = options[:name]
      @stop_signal = options[:stop_signal] || "TERM"
      super
    end

    def process_running?
      begin
        @pid ? ::Process.kill(0, @pid) : false
      rescue Errno::ESRCH => e
        false
      end
    end

    def start
      UI.info("Starting process #{@name}")
      @command.unshift(@env) if @env
      @process = IO.popen(@command)
      UI.info("Started process #{@name}")
      @pid = @process.pid
    end

    def stop
      if @process
        UI.info("Stopping process #{@name}")
        ::Process.kill(@stop_signal, @process.pid)
        ::Process.waitpid(@pid) rescue Errno::ESRCH
        @process.close
        @pid = nil
        UI.info("Stopped process #{@name}")
      end
    end

    def reload
      stop
      start
    end

    def run_all
      true
    end

    def run_on_change(paths)
      reload
    end
  end
end
