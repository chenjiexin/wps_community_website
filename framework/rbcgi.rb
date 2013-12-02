#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/libraries/dirs.rb"

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
