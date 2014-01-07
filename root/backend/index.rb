require 'libraries/auth'
require 'template/overall'
require 'cgi'

ensure_backend_access

CGI.new.out {
  <<EOF
  #{html_header "BACKEND"}
  <h1>Nothing here now</h1>
  #{html_tail}
EOF
}
