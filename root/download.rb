#!/usr/bin/env ruby

$mirrors = [
  # owner, contact, region, addr, provider
  [ "kingsoft", "wps_linux@kingsoft.com", "Italy/Europe", "http://37.247.55.101", "iperweb.com" ],
  [ "jinchizhong", "jinchizhong@kingsoft.com", "Los Angeles/America", "http://23.229.123.142", "servermania.com" ],
  ]

require 'cgi'
require 'yaml'
require 'template/overall.rb'
require 'libraries/dirs.rb'

$cgi = CGI.new

def lang_redirect lang, dest
  if $cgi['lang'] == lang
    $cgi.out('status' => '302', 'location' => dest) {''}
    exit 0
  end
end
lang_redirect 'zh', 'http://community.wps.cn/download/#alpha'

def html_version_item f
  cont = ""
  y = YAML.load_file(f)
  cont += "<h2>#{y["full_name"]}<span style='font-size:0.7em;'> [#{y["release_data"]}]</span></h2>"
  cont += ""
  cont += "<div class=\"ver_item\">"
  if y["whats_new"]
    cont += "<h3>What's new: </h3>"
    cont += "<ol>"
    cont += y["whats_new"].lines.collect { |l|
      l.chomp.length == 0 ? "" : "<li>#{l.chomp}</li>"
    }.join "\n"
    cont += "</ol>"
  end
  if y["release_notes"]
    cont += "<h3>Notes: </h3>"
    cont += "<ul>"
    cont += y["release_notes"].lines.collect {|l| "<li>#{l.chomp}</li>"}.join "\n"
    cont += "</ul>"
  end
  if y["addresses"]
    cont += "<h3>Addresses: </h3>"
    y["addresses"].each do |ver|
      address = ver["address"]
      filename = address.rpartition("/")[2]
      sha1 = ver["sha1sum"]
      cont += "<p class=\"dl_addr\">
        <a href=\"#{address}\" onclick=\"onDownload(this)\" data-filename=\"#{filename}\">#{filename}</a>
        <br/>SHA1: #{sha1}
        </p>"
    end
  end
  cont += "<h3>Get from other mirrors: </h3>"
  $mirrors.each do |mirror|
    cont += "<p class='dl_mirror'>#{mirror[2]}: <a href='#{mirror[3]}/#{y["linux_version_short"]}'>#{mirror[3]}/#{y["linux_version_short"]}</a></p>"
  end
  cont += "</div>"
  return cont
end

def html_versions
  files = Dir.glob(DATA_DIR + "/versions/**/*.yaml").sort{|a,b| -(File.basename(a).to_i <=> File.basename(b).to_i) }
  files.collect do |f|
    html_version_item f
  end.join "\n"
end

cont = <<EOF
#{html_header "Downloads"}
<script type="text/javascript">
  function onDownload(n)
  {
    url = "/bin/st.rb?t=download&amp;a=" + n.getAttribute("data-filename") + "&amp;r=" + Math.random();
    a = new XMLHttpRequest();
    a.open("GET", url , false);
    a.send();
  }
</script>
<div class="body">
<h1>Product Download</h1>
  <div class="framed" style="font-size:1.2em">If you like our product, tell your friends, if you don't, please <a href="/forum/">tell us</a>! (^_^)
  </div>
#{html_versions}
</div>
#{html_tail}
EOF

$cgi.out {
  cont
}
