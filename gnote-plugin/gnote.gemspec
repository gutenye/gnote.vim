Kernel.load File.expand_path("../lib/gnote/version.rb", __FILE__)

Gem::Specification.new do |s|
	s.name = "gnote"
	s.version = GNote::VERSION
	s.summary = "a gnote.vim plugin"
	s.description = <<-EOF
a gnote.vim plugin
	EOF

	s.author = "Guten"
	s.email = "ywzhaifei@gmail.com"
	s.homepage = "http://github.com/GutenYe/gnote-plugin"
	s.rubyforge_project = "xx"

	s.files = `git ls-files`.split("\n")
  s.executables = ["gnote"]

	s.add_dependency "tagen", "~>2.0.0"
	s.add_dependency "optimism", "~>3.3.0"
	s.add_dependency "pa", "~>1.3.0"
	s.add_dependency "thor"
end
