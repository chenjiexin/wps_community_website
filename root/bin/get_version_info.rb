require 'yaml'
require 'json'

puts "Content-Type: text/plain"
puts

$d = $root2 + "/data/versions"

def get_last_version
  x = Dir.new($d).each.to_a.sort do |a,b| a.to_i <=> b.to_i end
  return x.last.to_i
end

def get_address v
  y = YAML.load_file($d + "/" + v + ".yaml")
  y['addresses'].collect do |t|
    t['type'] + " " + t['sha1sum'] + " " + t['address']
  end.join "\n" 
end

def get_info v
  y = YAML.load_file($d + "/" + v + ".yaml")
  return JSON.generate y
end

def get_versions
  x = Dir.new($d).each.to_a.sort do |a,b| - a.to_i <=> b.to_i end
  x.collect do |a|
    if a =~ /[0-9]+\.yaml/
      a.to_i.to_s
    else
      nil
    end
  end.select {|a| a}.join "\n"
end

def help
  "Usage: \n" + 
  "Get Last Version: get_version_info.rb?c=get_last_version\n" + 
  "Get All Versions: get_version_info.rb?c=get_versions\n" + 
  "Get Last Version Download Address: get_version_info.rb?c=get_address\n" +
  "Get Special Version Download Address: get_version_info.rb?c=get_address&v=4096\n" +
  "Get Last Version Info: get_version_info.rb?c=get_info\n" +
  "Get Special Version Info: get_version_info.rb?c=get_info&v=4096\n"
end

cmd = $cgi['c']

if cmd == "get_last_version"
  puts get_last_version
elsif cmd == "get_versions"
  puts get_versions
elsif cmd == "get_address"
  v = $cgi['v'] != "" ? $cgi['v'] : get_last_version
  puts get_address(v.to_s)
elsif cmd == "get_info"
  v = $cgi['v'] != "" ? $cgi['v'] : get_last_version
  puts get_info(v.to_s)
else
  puts help
end
