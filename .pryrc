module Pry::Larry
  MESSAGE_FORMAT = "%{LarrySays} %{WallTime}s"
  MEMORY = Hash.new{|h,k| h[k] = [] }
  BEFORE_EVAL = ->(_, pry) do
    MEMORY[pry.hash].push Time.now.to_f
  end
  AFTER_EVAL = ->(_, pry) do
    walltime = Time.now.to_f - MEMORY[pry.hash][-1]
    if pry.config.larry.speak_if.call(walltime)
      pry.output.puts MESSAGE_FORMAT % {
        :LarrySays => Pry::Helpers::Text.green("Larry says:"),
        :WallTime  => sprintf("%.2f", walltime)
      }
    end
  end
  BEFORE_SESSION = ->(_,_, pry) do
    Pry::Larry.start(pry) if pry.config.larry.auto_start
  end
  AFTER_SESSION = ->(_, _, pry) do
    MEMORY.delete(pry.hash)
  end

  def self.start(pry)
    if not pry.config.hooks.hook_exists? :before_eval, BEFORE_EVAL.hash
      pry.config.hooks.add_hook :before_eval, BEFORE_EVAL.hash, BEFORE_EVAL
      pry.config.hooks.add_hook :after_eval,  AFTER_EVAL.hash , AFTER_EVAL
      pry.config.hooks.add_hook :after_session, AFTER_SESSION.hash , AFTER_SESSION
    end
  end

  def self.stop(pry)
    pry.config.hooks.delete_hook :before_eval, BEFORE_EVAL.hash
    pry.config.hooks.delete_hook :after_eval , AFTER_EVAL.hash
    pry.config.hooks.delete_hook :after_session , AFTER_SESSION.hash
    MEMORY[pry.hash].clear
  end

  require 'pry' if not defined?(Pry::ClassCommand)
  class LarryCommand < Pry::ClassCommand
    match 'larry'
    group 'pry-larry'
    description 'Ask larry to start or stop counting wall-clock time.'
    command_options argument_required: true

    def process(input)
      case input.strip.downcase
      when "start" then Pry::Larry.start(_pry_)
      when "stop"  then Pry::Larry.stop(_pry_)
      end
    end
  end
  Pry::Commands.add_command(LarryCommand)
  Pry.config.hooks.add_hook :before_session, BEFORE_SESSION.hash, BEFORE_SESSION
  Pry.config.larry = Pry::Config.from_hash({auto_start: false, speak_if: ->(walltime){ true }}, nil)
  Pry.config.larry.auto_start = true
  Pry.config.larry.speak_if = ->(walltime) {
        walltime > 0
  }
end
