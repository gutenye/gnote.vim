#!/usr/bin/env ruby

require "tagen/core"
require "pa"
require "optimism"

Rc = Optimism <<EOF
p:
  tags = Pa("tags")
EOF

fname = "a"

tags = <<EOF
!_TAG_FILE_SORTED\t1

EOF

File.read(fname).scan(/\|([^\n ]+)\|/) {|(id)|
  tags <<  "#{id}\t#{fname}\t/*#{id}*\n"
}

puts tags

File.write Rc.p.tags.p, tags
