#!/usr/bin/env ruby

require 'cgi'
require_relative 'libraries/dirs.rb'
require 'template/overall.rb'

$cgi = CGI.new
$mdfile = ENV['DOCUMENT_ROOT'] + ENV['REQUEST_URI']
$mdfile.gsub!('//', '/')

begin
  cont = `markdown "#{$mdfile}" 2>&1`
  $cgi.out do
    html_header(ENV["REQUEST_URI"]) +
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

