#!/usr/bin/env ruby
require 'cgi'

if ARGV.size == 0
  return 1
end

$cgi = CGI.new
$cookies = []
$root = ENV['DOCUMENT_ROOT'] ? ENV['DOCUMENT_ROOT'] : Dir.pwd
$root2 = $root + "/.."

$LOAD_PATH << $root

begin
  require ARGV[0]
rescue Exception => e
  puts "Content-type: text/plain; charset=utf-8"
  puts "Status: 500 Internal Server Error"
  puts
  puts e.message
  e.backtrace.each do |x|
    puts x
  end
end
