#!/usr/bin/env ruby

require 'cgi'
require 'template/overall.rb'
require 'libraries/dirs.rb'

$url = "http://" + ENV['HTTP_HOST'] + ENV['REQUEST_URI']
$remote = ENV['REMOTE_ADDR']

def write_log
  open(LOG_DIR + "/404.log", "a") do |f|
    f.puts Time.now.strftime("%F %T %z") + " " + $remote + " " + $url
  end
end

write_log

cont = <<EOF
#{html_header "FAQ"}
<div class="body">
  <h1>Page Not Found</h1>
  Sorry, the page you visit does not exist, the problem we have been recorded.
  If you can provide more details, please <a href="mailto:linux_wps@kingsoft.com">contact us</a>.<br/><br/>
  <h3>Detail:</h3>
  <div class="framed">
    Domain: #{ENV['HTTP_HOST']}<br/>
    Request URI: #{ENV['REQUEST_URI']}<br/>
  </div>
</div>
#{html_tail}
EOF

CGI.new.out("status" => "404") {
  cont
}

