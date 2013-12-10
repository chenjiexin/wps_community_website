#!/usr/bin/env ruby

require 'cgi'
require 'zlib'
require 'libraries/dirs.rb'

def get_ref_name q
  Zlib::crc32(q).to_s 16
end

Newsinfo = Struct.new(:title, :content)

def read_news fname
  title = ""
  content = ""

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
        content += "\n<br/>"
      else
        content += l + " "
      end
    end
  end
  return Newsinfo.new title, content
end

def rss_items
  cont = ""
  news = Dir.glob(DATA_DIR + "/news/*.news").sort {|a,b| -(File.basename(a).to_i <=> File.basename(b).to_i)}
  news.each do |n|
    newsinfo = read_news n
    cont += "<item><title>#{newsinfo.title}</title>
        <link>http://wps-community.org</link>
        <description>#{CGI.escapeHTML newsinfo.content}</description>
        <guid>#{get_ref_name newsinfo.title}</guid></item>"
  end
  return cont
end

cont = <<EOF
<?xml version='1.0' encoding='UTF-8'?><?xml-stylesheet type='text/xsl' href='http://cnbeta.feedsportal.com/xsl/eng/rss.xsl'?>
<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" version="2.0">
  <channel>
    <title>Kingsoft WPS Office Community</title>
    <link>http://wps-community.org</link>
    <description>wps-community.org - Kingsoft WPS Office Community</description>
    <copyright>@kingsoft.com</copyright>
#{rss_items}
  </channel>
</rss>
EOF

cgi = CGI.new
cgi.out {
  cont
}
