#!/usr/bin/env ruby

require 'cgi'
require 'template/overall.rb'
require 'yaml'

cont = <<EOF
#{html_header "About us"}
<div class="body">
<h1>todo...</h1>
</div>
#{html_tail}
EOF

cgi = CGI.new
cgi.out {
  cont
}
