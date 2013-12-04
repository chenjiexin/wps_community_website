#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/libraries/dirs.rb"
require 'cgi'
require 'template/overall.rb'

$cgi = CGI.new
$mdfile = ENV['DOCUMENT_ROOT'] + ENV['REQUEST_URI']
$mdfile.gsub!('//', '/')

begin
  cont = `markdown "#{$mdfile}" 2>&1`
  title = open($mdfile).readline
  $cgi.out do
    html_header(title) +
        "<div class='markdown'>" + cont + "</div>" +
        html_tail
  end
rescue Exception => e
  puts "Content-type: text/plain; charset=utf-8"
  puts "Status: 500 Internal Server Error"
  puts
  puts e.message
  e.backtrace.each do |x|
    puts x
  end
end

