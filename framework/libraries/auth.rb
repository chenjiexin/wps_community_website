require 'libraries/db'
require 'cgi'

def ensure_backend_access
  st = db_website.prepare "select * from backend_whitelist where ip = ?"
  rs = st.execute ENV['REMOTE_ADDR']
  if rs.num_rows == 0
    require ENV['DOCUMENT_ROOT'] + "/404.rb"
  end
end
