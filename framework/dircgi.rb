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

def humen_readable_size file_path
  s = File.size(file_path)
  if s < 1000
    return "#{s} B"
  elsif s < 1024000
    return format("%.1f KB", s / 1024.0)
  elsif s < 1048576000
    return format("%.1f MB", s / 1048576.0)
  else
    return format("%.1f GB", s / 1073741824.0)
  end
end

def html_sub_dir
  cont = "<div class='file_list'><table style='width:100%;'>"
  cont += "<thead><tr><th class='file_name'>File Name</th><th class='file_size'>File Size</th><th class='file_time'>Modify Time (UTC)</th></tr></thead>"
  x = Dir.entries($dirpath).each.to_a.sort do |a, b| a.to_s <=> b.to_s end
  x.each do |a|
    if (a != '.' && a != 'README.md')
      if (FileTest.directory?($dirpath + "/" +a))
        cont += "<tr><td class='file_name'><a href=\"#{a}/\">#{a}</a>/</td>
                     <td class='file_size'>-</td>
                     <td class='file_time'>#{File.mtime($dirpath + "/" +a).getutc.strftime "%F %T"}</td></tr>"
      else 
        cont += "<tr><td class='file_name'><a href=\"#{$filepath+"/" +a}\">#{a}</a></td>
                     <td class='file_size'>#{humen_readable_size($dirpath + "/" +a)}</td>
                     <td class='file_time'>#{File.mtime($dirpath + "/" +a).getutc.strftime "%F %T"}</td></tr>"
      end
    end
  end
  cont += "</table></div>"

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
