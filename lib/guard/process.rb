require 'guard'
require 'guard/guard'

module Guard
  class Process < Guard
    VERSION = "0.0.1"

    def initialize(watchers = [], options = {})
      @process = nil
      @command = options[:command]
      @env = options[:env] 
      @name = options[:name]
      @stop_signal = options[:stop_signal] || "TERM"
      super
    end

    def start
      UI.info("Starting #{@name}")
      @process = @env ? ::IO.popen([@env, @command]) : IO.popen(@command)
    end

    def stop
      if @process
        UI.info("Stopping #{@name}")
        ::Process.kill(@stop_signal, @process.pid)
        ::Process.waitpid(@process.pid) rescue Errno::ESRCH
        @process.close
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
