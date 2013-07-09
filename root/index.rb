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
    <img src="/images/aaa.png">
    <img src="/images/aaa.png">
    <img src="/images/aaa.png">
    <img src="/images/aaa.png">
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
