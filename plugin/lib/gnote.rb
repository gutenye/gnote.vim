libdir = File.dirname(__FILE__); $LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "pd"
require "optimism"
require "pa"

module GNote
  DEBUG = true

  autoload :VERSION, "gnote/version"
  autoload :UI, "gnote/ui"
  autoload :CLI, "gnote/cli"
  autoload :Tags, "gnote/tags"

  Error = Class.new Exception
  EFatal = Class.new Exception
  Rc = Optimism.require "gnote/rc", "~/.gnoterc"

  class << self
    attr_accessor :ui

    def ui
      @ui ||= UI.new
    end
  end
end
