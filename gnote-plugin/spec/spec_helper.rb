require "pd"
require "gnote"

$spec_dir = File.expand_path("..", __FILE__)
$spec_data = File.join($spec_dir, "data")
$spec_tmp = File.join($spec_dir, "tmp")

Rc = GNote::Rc
Rc._merge! Optimism <<EOF
  p:
    home = Pa("#{$spec_data}/_gnote")
    homerc = Pa("#{$spec_data}/_gnoterc")

    note = Pa("#{$spec_data}/note")
    tagsdir = Pa("#{$spec_data}/_note.tags")
    user_tags = Pa("#{$spec_data}/_notetags")
    tags_output = Pa("#{$spec_data}")
EOF

require "thor"
GNote.ui = GNote::UI::Shell.new(Thor.new.shell)

RSpec.configure do |config|
  def capture(stream)
		require "stringio"
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

  alias :silence :capture
end

module RSpec
  module Core
    module DSL
      def xdescribe(*args, &blk)
        describe *args do
          pending 
        end
      end

      alias xcontext xdescribe
    end
  end
end

def public_all_methods(*klasses)
	klasses.each {|klass|
		klass.class_eval {
      public *(self.protected_instance_methods(false) + self.private_instance_methods(false))
      public_class_method *(self.protected_methods(false) + self.private_methods(false))
    }
	}
end
