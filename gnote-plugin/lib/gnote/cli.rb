require "thor"

module GNote
  class CLI < Thor
    class_option "no-color", :banner => "Disable colorization in output", :type => :boolean
    class_option "verbose",  :aliases => "-V", :banner => "Enable verbose output mode", :type => :boolean
    class_option "log",      banner: "log file", type: :string

    attr_reader :o

    def initialize(*)
      super
      o = @o = options.dup

      GNote.ui = if o["log"] then
        require "logger"
        UI::Logger.new(::Logger.new(o["log"]))
      else
        the_shell = (options["no-color"] ? Thor::Shell::Basic.new : shell)
        UI::Shell.new(the_shell)
      end

      GNote.ui.debug! if options["verbose"]
    end

    desc "tags", "generate a tags file"
    def tags
      GNote::Tags.tags
    end

    desc "watch", "watch note/ directory, and automatical generate tags file"
    method_option "daemon", desc: "daemonize", type: :boolean
    method_option "pidfile", default: "gnote.pid", desc: "pid file", type: :string
    def watch
      GNote::Tags.tags
      GNote::Tags.watch o
    end
  end
end
