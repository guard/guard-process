require 'guard'
require 'guard/guard'
require 'spoon'

module Guard
  class Process < Guard
    def initialize(watchers = [], options = {})
      @pid = nil
      @command = options.fetch(:command).split(" ")
      @env = options[:env] || {}
      @name = options[:name]
      @dir = options[:dir] || Dir.getwd
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
      original_env = {}
      @env.each_pair do |key, value|
        original_env[key] = ENV[key]
        ENV[key] = value
      end
      Dir.chdir(@dir) do
        @pid = Spoon.spawnp(*@command)
      end
      original_env.each_pair do |key, value|
        ENV[key] = value
      end
      UI.info("Started process #{@name}")
    end

    def stop
      if @pid
        UI.info("Stopping process #{@name}")
        ::Process.kill(@stop_signal, @pid)
        ::Process.waitpid(@pid) rescue Errno::ESRCH
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
