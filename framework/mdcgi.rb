#!/usr/bin/env ruby
require 'cgi'

if ARGV.size == 0
  return 1
end

$cgi = CGI.new
$root = ENV['DOCUMENT_ROOT'] ? ENV['DOCUMENT_ROOT'] : Dir.pwd
$LOAD_PATH << $root

require 'parts/parts.rb'

begin
  cont = `markdown "#{ARGV[0]}" 2>&1`
  $cgi.out do
    html_header(ENV["SCRIPT_NAME"]) + cont + html_tail
  end
rescue
  puts "Content-type: text/plain; charset=utf-8"
  puts "Status: 500 Internal Server Error"
  puts
  puts e.message
  e.backtrace.each do |x|
    puts x
  end
end


