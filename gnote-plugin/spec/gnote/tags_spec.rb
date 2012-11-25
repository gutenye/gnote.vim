# encoding: utf-8
require "spec_helper"
require "tagen/core/file"

Tags = GNote::Tags
public_all_methods Tags
#GNote.ui.debug!

describe Tags do 
  before :each do
    Pa.empty_dir Rc.p.note
    Pa.empty_dir Rc.p.tagsdir

    @tags = Tags.new
  end

  describe "#generate_tags" do
    # note/
    #   dir/hello.gnote with "∗id∗\n"
    before :each do
      File.write "#{Rc.p.note}/dir/hello.gnote", "∗id∗\n", :mkdir => true
    end

    it "works" do
      @tags.generate_tags(Pa("dir/hello.gnote"))

      File.read("#{Rc.p.tagsdir}/dir/hello.gnote").should =~ %r~id\t#{Rc.p.note}/dir/hello.gnote\t\/∗id∗\n~
    end
  end

  describe "#concat_tags" do
    # .note.tags/
    #   foo with "foo\n"
    #   bar with "bar\n"
    before :each do
      File.write "#{Rc.p.tagsdir}/foo", "foo\n"
      File.write "#{Rc.p.tagsdir}/bar", "bar\n"
    end

    it "works" do
      @tags.concat_tags

      File.read("#{Rc.p.tags_output}/tags").should =~ %r~bar\nfoo~
    end
  end

  describe "#sort" do
    it "works" do
      a = "foo\nbar\n"
      b = "bar\nfoo\n"

      @tags.sort(a).should == b
    end
  end

  describe "#tags" do
    # note/
    #   tags with "a"
    #   foo with "∗id∗"
    #
    # .note.tags/
    #   foo with  "c"
    before :each do
      File.write "#{Rc.p.note}/foo.gnote", "∗id∗"

      # helper
      File.write "#{Rc.p.tags_output}/tags", "a"
      File.write "#{Rc.p.tagsdir}/foo", "c"
    end

    it "works" do
      @tags.tags

      File.read("#{Rc.p.tags_output}/tags").should =~ %r~id\t#{Rc.p.note}/foo.gnote\t\/∗id∗\n~
    end
  end

  describe "#skip_file" do
    it "works" do
      @tags.skip_file(Pa("tags")).should be_true
      @tags.skip_file(Pa("foo~")).should be_true
      @tags.skip_file(Pa(".foo.swp")).should be_true
      @tags.skip_file(Pa("foo")).should be_false
    end
  end
end
