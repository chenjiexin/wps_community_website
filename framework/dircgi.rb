#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/libraries/dirs.rb"
require 'cgi'
require 'template/overall.rb'

$dirpath = ENV['DOCUMENT_ROOT'] + ENV['REQUEST_URI']
$dirpath.gsub!('//', '/')
$filepath = ENV['REQUEST_URI']
$home = ENV['DOCUMENT_ROOT']

def html_readme
  cont = ""
  if File.exist?($dirpath + "/README.md")
    cont = "<div class='markdown'>"
    cont += `markdown #{$dirpath}"/README.md" 2>&1`
    cont += "<br/></div>"
  end
  return cont
end

def html_path
  cont = "<h1>"
  x = $filepath.split '/'
  x.shift
  x.each_index do |i|
    cont += " &gt; <a href='/#{x[0..i].join '/'}/'>#{x[i]}</a>"
  end
  cont += "</h1>"
  return cont
end

def html_sub_dir
  cont = ""
  x = Dir.entries($dirpath).each.to_a.sort do |a, b| a.to_s <=> b.to_s end
  cont += "<div class=\"mui_item\">"
  cont += "<table summary=\"Directory Listing\" cellpadding=\"0\" border=\"0\" width=\"1000\">"
  cont += "<thread><tr><td class=\"n\" style=\"font-size:18px;\"><b>Name</b></td><td class=\"m\" style=\"font-size:18px;\"><b>Last Modified Time</b></td></tr></thread>"
  x.collect do |a|
    if (a != '.' && a != '..' && a != 'README.md')
      if (FileTest.directory?($dirpath + "/" +a))
        cont += "<tr><td class=\"n\"><a href=\"#{a}/\">#{a}/</a></td> <td class=\"m\">#{File.mtime($dirpath + "/" +a)}</td></tr>"
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
#{html_header $filepath}
#{html_path}
#{html_readme}
#{html_sub_dir}
#{html_tail}
EOF

cgi = CGI.new
cgi.out{
  cont
}
