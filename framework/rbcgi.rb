#!/usr/bin/env ruby

require 'pathname'

if ARGV.size == 0
  return 1
end

framepath = Pathname.new(__FILE__).dirname

$LOAD_PATH << framepath

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
