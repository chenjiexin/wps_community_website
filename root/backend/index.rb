require 'libraries/auth'
require 'cgi'

ensure_backend_access

CGI.new.out {
  "Nothing here now."
}
