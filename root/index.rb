require 'cgi'
require 'include/parts.rb'

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
  news = Dir.glob($root2 + "/data/news/*.news").sort {|a,b| -(File.basename(a).to_i <=> File.basename(b).to_i)}
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
    <img src="/images/slide-wps.png">
    <img src="/images/slide-wpp.png">
    <img src="/images/slide-et.png">
    <a href="#" class="slidesjs-previous slidesjs-navigation"><img src="/images/left.png"></i></a>
    <a href="#" class="slidesjs-next slidesjs-navigation"><img src="/images/right.png"></i></a>
  </div>
  <div class="center">
    Kingsoft Office, the simple, effective, powerful and comfortable office suite, since 1989. It had landed Linux. <br/>
    Let us do our best to make a best Linux Office Suite.
    For <a href="http://www.ksosoft.com/downloads/windows.html" target="_blank">Windows</a>/
    <a href="http://www.ksosoft.com/downloads/android.html" target="_blank">Android</a>/
    <a href="http://www.ksosoft.com/downloads/ios.html" target="_blank">iOS</a>, 
    click <a href="http://www.ksosoft.com/" target="_blank">here</a>, please.
  </div>
  <script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
  <script src="js/jquery.slides.min.js"></script>
  <script>
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

$cgi.out {
  cont
}
