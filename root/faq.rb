require 'cgi'
require 'include/parts.rb'
require 'yaml'

def get_ref_name q
  r = ""
  q.each_char do |x|
    if x >= 'a' and x <= 'z'
      r += x
    elsif x >= 'A' and x <= 'Z'
      r += x.downcase
    elsif x >= '0' and x <= '9'
      r += x
    elsif x == ' ' or x == '-'
      r += '_'
    end
  end
  return r
end

def html_faq
  faqs = YAML.load_file $root2 + "/data/faqs.yaml"
  faqs.collect do |faq|
    "<a name=\"#{get_ref_name faq["Q"]}\"></a>
    <b>Q: #{faq["Q"]}</b><br/>
    A: #{faq["A"]}<br/><br/>"
  end.join "\n"
end

cont = <<EOF
#{html_header "FAQ"}
<div class="body">
<h1>FAQ</h1>
#{html_faq}
</div>
Cannot find what you need? <a href="/forum">Try forum here</a>.
<br/>
#{html_tail}
EOF

$cgi.out {
  cont
}
