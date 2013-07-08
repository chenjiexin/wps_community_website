require 'cgi'
require 'parts/parts.rb'

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
<ul>
  <li><b>About Kingsoft Office:</b> Kingsoft Office ( also known as WPS Office ) is a vibrant office suite since 1989.
  We have more than 200 developers and always devote ourselves to creating comfortable, efficient and smart office experience.
  Kingsoft Office is cross-platform commercial software. So far, we have <a href="http://www.ksosoft.com/downloads/windows.html">Windows</a> 
  and <a href="/download.html">Linux</a> versions for desktop, <a href="http://www.ksosoft.com/downloads/android.html">Android</a>
  and <a href="http://www.ksosoft.com/downloads/ios.html">iOS</a> versions for mobile.
  For more information, you can visit our <a href="http://www.ksosoft.com">official website</a>, or 
  click <a href="http://www.ksosoft.com/company/index.html">here</a> to our official website's about page, directly.</li>
  <li><b>About us:</b> We are a small branch of the Kingsoft Office team,
  which also devotes itself to porting Kingsoft Office to Linux and Linux-like systems, 
  and offers their users native experience.</li>
  <li><b>Annotation:</b> Due to some historical reasons, our product have had several different names: 
  <b>WPS Office</b> (widely used in Asian area, can be abbreviated to <b>WPS</b>);
  <b>Kingsoft Office</b>(widely used in Europe and America countries, can be abbreviated to <b>KSO</b>),
  <b>Kingsoft WPS Office</b>(used to let all of us understand).
  Those names mentioned above can be used on our site.</li>
  <li><b>Help us:</b> If you like Kingsoft Office, tell your friends, please. Kingsoft Office also have 
  Windows/Android/iOS Versions. You can get it <a href="http://www.ksosoft.com/">here</a>.</li>
</ul>
<h1>Latest Announcements</h1>
#{html_news}
#{html_tail}
EOF

$cgi.out {
  cont
}
