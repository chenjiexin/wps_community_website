#!/usr/bin/env ruby

require 'cgi'
require 'template/overall.rb'
require 'libraries/dirs.rb'

NewsInfo = Struct.new(:title, :content)

def read_news fname
  title = ""
  content = "<p>"

  open(fname) do |f|
    f.each_line do |l|
      l.chomp!
      if l =~ /^=/
        break
      end
      title += l
    end
    f.each_line do |l|
      l.chomp!
      if l.size == 0
        content += "</p><br/>\n<p>"
      else
        content += l + " "
      end
    end
    content += "</p>"
  end
  return NewsInfo.new title, content
end

def html_news
  cont = ""
  news = Dir.glob(DATA_DIR + "/news/*.news").sort {|a,b| -(File.basename(a).to_i <=> File.basename(b).to_i)}
  news.each do |n|
    newsinfo = read_news n
    cont += "<h2>#{newsinfo.title}</h2><div class=\"framed\">#{newsinfo.content}</div>"
  end
  return cont
end

cont = <<EOF
#{html_header "Home"}
<h1>Welcome to Kingsoft Office International Community</h1>
  <div id="slides">
    <img src="/images/slide-wps.png" alt="Kingsoft Writer screenshot"/>
    <img src="/images/slide-wpp.png" alt="Kingsoft Presentation screenshot"/>
    <img src="/images/slide-et.png" alt="Kingsoft Spreadsheets screenshot"/>
    <a href="#" class="slidesjs-previous slidesjs-navigation"><img src="/images/left.png" alt="left arrow"/></a>
    <a href="#" class="slidesjs-next slidesjs-navigation"><img src="/images/right.png" alt="right arrow"/></a>
  </div>
  <div class="center">
    Kingsoft Office is a simple, powerful office suite with a confortable interface. 
    Since 1988 Kingsoft has been thought of as one of the best office suites available, 
    but there is no Linux version! Help us create the best Linux Office Suite.
    We're also working on versions for <a href="http://www.ksosoft.com/downloads/windows.html" target="_blank">Windows</a>, 
    <a href="http://www.ksosoft.com/downloads/android.html" target="_blank">Android</a> and 
    <a href="http://www.ksosoft.com/downloads/ios.html" target="_blank">iOS</a>, 
    <a href="http://www.ksosoft.com/" target="_blank">find out more here</a>.
  </div>
  <script src="http://code.jquery.com/jquery-1.9.1.min.js" type="text/javascript"></script>
  <script src="js/jquery.slides.min.js" type="text/javascript"></script>
  <script type="text/javascript">
    $(function() {
      $('#slides').slidesjs({
        width: 960,
        height: 256,
        play: {
          interval: 5000,
          auto: true,
          pauseOnHover: false
        },
        navigation: false,
        pagination: false
      });
    });
  </script>
<h1>Latest Announcements</h1>
#{html_news}
#{html_tail}
EOF

CGI.new.out {
  cont
}
