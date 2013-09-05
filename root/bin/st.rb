#!/usr/bin/env ruby

require 'cgi'
cgi = CGI.new

open(ENV["DOCUMENT_ROOT"] + "../log/statistics.log", "a") do |f|
  f.puts Time.now.strftime("%F %T %z") + " " + cgi["t"] + " " + cgi["a"]
end

puts "OK"

