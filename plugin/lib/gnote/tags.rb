# encoding: utf-8
require "tagen/core/file"
require "rb-inotify"

module GNote
  class Tags 
    class << self
      def watch(o)
        pd o

        if o["daemon"] 
          Process.daemon

          File.write o["pidfile"], Process.pid

          trap(:TERM) { 
            File.delete o["pidfile"] 
            exit 
          }
        end

        Tags.new.watch
      end

      def tags
        Tags.new.tags
      end
    end

    # task
    def tags
      Pa.empty_dir Rc.p.tagsdir

      Pa.each_r(Rc.p.note) {|p|
        next if p.directory? || p.symlink? || p.ext != ".gnote" || skip_file(p.rel)

        generate_tags(Pa(p.rel2, :base_dir => Rc.p.note.p))
      }

      concat_tags
    end

    # task
    def watch
      notifier = INotify::Notifier.new

      notifier.watch(Rc.p.note.p, :modify, :delete, :recursive) { |e|
        file = Pa(e.name, :base_dir => Rc.p.note.p) # "ds/pa.gnote"
        if file.directory? || file.symlink? || file.ext != ".gnote" || skip_file(file)
          # skip
        else
          if e.flags.include?(:modify)  
            GNote.ui.debug "MODIFY #{file}"
            generate_tags(file)
          elsif e.flags.include?(:delete)
            GNote.ui.debug "DELETE #{file}"
            Pa.rm "#{Rc.p.tagsdir}/#{file}"
          end

          concat_tags
        end
      }

      GNote.ui.say ">> BEGIN WATCH AT #{Rc.p.note}"
      notifier.run
    end

  protected

    # generate one tag file from the file.
    #
    # @example
    #
    #   generate_tags(Pa("hello.gnote", :base_dir => "/home/guten/note"))
    #
    def generate_tags(file)
      GNote.ui.debug "GENERATE TAGS #{file}"
      content = ""

      File.read("#{Rc.p.note}/#{file}").scan(/∗([^\n ]+)∗/) {|(id)|
        content <<  "#{id}\t#{Rc.p.note}/#{file}\t/∗#{regexp_escape(id)}∗\n"
      }

      File.write "#{Rc.p.tagsdir}/#{file}", content, :mkdir => true
    end

    # concat all per-file tag-data to 'tags' file.
    #
    #
    def concat_tags
      content = ""

      content << user_tags

      Pa.each_r(Rc.p.tagsdir) {|p|
        next unless p.file?

        content << File.read(p.p)
      }

      content = sort(content)

      content = <<-EOF
!_TAG_FILE_SORTED\t1

#{content}
      EOF

      File.write "#{Rc.p.tags_output}/tags", content
    end

    # vim pattern escape
    def regexp_escape(pat)
      pat.gsub(%r~/~, "\\/")
    end

    # return content from Rc.p.user_tags
    def user_tags
      if Rc.p.user_tags.exists? then
        return File.read(Rc.p.user_tags.p)
      else
        return ""
      end
    end
    
    def sort(content)
      content = content.split(/\n+/)
      content = content.sort_by{|v| v.split(/\t/)[0]}
      content.join("\n") + "\n"
    end

  private
    # skip_file(Pa("foo/bar.gnote"))
    #
    #   tags
    #   vim: .swp backup~
    #   .git
    def skip_file(file)
      file = file.p

      %w[tags .git].include?(file) || 
        file =~ /^\..*\.sw(p|o)$/ || 
        file =~ /~$/
    end
  end
end
