#!/usr/bin/env ruby

require 'cgi'
require '../root/include/parts.rb'

$dirpath = ENV['DOCUMENT_ROOT'] + ENV['DOCUMENT_URI']
$filepath = ENV['DOCUMENT_URI'] 
def html_readme
  cont = ""
  if File.exist?($dirpath + "/README.md")
    cont = `markdown #{$dirpath}"/README.md" 2>&1`
  end
  return cont
end

def html_sub_dir
    cont = ""
  x = Dir.entries($dirpath).each.to_a.sort do |a, b| a.to_s <=> b.to_s end
  cont += "<div class=\"mui_item\">"
  cont += "<table summary=\"Directory Listing\" cellpadding=\"0\" cellspacing=\"10\" border=\"0\" width=\"1000\">"
  cont += "<thread><tr><td class=\"n\" style=\"font-size:18px;\"><b>Name</b></td><td class=\"m\" style=\"font-size:18px;\"><b>Last Modified Time</b></td></tr></thread>"
  cont += "<tr><td class=\"n\"><a href=\"#{$filepath + "/.." }/\"> Parent Directory</a></td></tr>"
  x.collect do |a|
    if (a != '.' && a != '..' && a != 'README.md')
      if (FileTest.directory?($dirpath + "/" +a))
        cont += "<tr><td class=\"n\"><a href=\"#{a}\">#{a}</a></td> <td class=\"m\">Click to see the last modified time</td></tr>"
      else 
        cont += "<tr><td class=\"n\"><a href=\"#{$filepath+"/" +a}\">#{a}</a></td> <td class=\"m\">#{File.mtime($dirpath + "/" +a)}</td></tr>"
      end
    end
  end
  cont += "</table>"
  cont += "</div>"
  return cont
end


cont = <<EOF
#{html_header "Development"}

#{html_readme}
<p>
<h2> File or Dirs underflow</h2>
#{html_sub_dir}

#{html_tail}
EOF

cgi = CGI.new
cgi.out{
  cont
}
