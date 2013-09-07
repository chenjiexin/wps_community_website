#!/usr/bin/env ruby

require 'yaml'

puts "Content-Type: text/plain"
puts 

if not $root2
  $root2 = "../.."
end

$version_data_dir = $root2 + "/data/versions"
$beta_dir = $version_data_dir + "/beta"
$alpha_dir = $version_data_dir + "/alpha"

def get_last_beta_version
  x = Dir.new($beta_dir).each.to_a.sort do |a, b| a.to_i <=> b.to_i end
  return x.last.to_i
end

def get_beta_version_info version
  y = YAML.load_file($beta_dir + "/" + version + ".yaml")
  return y
end

def get_last_alpha_version
  x = Dir.new($alpha_dir).each.to_a.sort do |a, b| a.to_i <=> b.to_i end
  return x.last.to_i
end

def get_alpha_version_info version
  y = YAML.load_file($alpha_dir + "/" + version + ".yaml")
  return y
end



alpha_version_num = get_alpha_version_info(get_last_alpha_version.to_s);
beta_version_num = get_beta_version_info(get_last_beta_version.to_s);

puts alpha_version_num["version"] +"/" + beta_version_num["version"]

qurey = ENV['QUERY_STRING']

qurey = qurey.gsub("&", " ")
qurey = qurey.gsub(/\%[0-9]{2}/, "")

logpath = $root2 + "/log/uselog.log"

if qurey == ""
else
  open(logpath, "a") do |line|
    line.puts Time.now.strftime("%F %T %z") + " " + qurey 
  end
end

