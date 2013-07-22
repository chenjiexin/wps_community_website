require 'cgi'
require 'include/parts.rb'

cont = <<EOF
#{html_header "Development"}
<div class="body">
<h1>Develop for KSO/WPS</h1>
  <h2>Translate KSO/WPS</h2>
    Project Address: <a href="https://github.com/wps-community/wps_i18n" target="_blank">https://github.com/wps-community/wps_i18n</a>
    <br/><b>Note: </b>We will adjust some framework about internationalization for KSO/WPS in alpha 12.
    So some of translation items will be lost in alpha 12(about 10-30%). 
    Beta 2 will be released base on alpha 11. And beta 2 will be maintained for a long time.
    If you feel worried about it, you can wait alpha 12. 
  <h2>Qt modified by KSO/WPS</h2>
    Project Address: <a href="https://gitcafe.com/wpsv9/qt-kso-integration" target="_blank">https://gitcafe.com/wpsv9/qt-kso-integration</a>
  <h2>WPS Community Code</h2>
    Project Address: <a href="https://github.com/wps-community/wps_community_website" target="_blank">https://github.com/wps-community/wps_community_website</a>
</div>
<br/>
#{html_tail}
EOF

$cgi.out {
  cont
}
