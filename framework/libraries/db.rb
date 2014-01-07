require 'mysql'

def db_website
  if !$db_website
    $db_website = Mysql.new '127.0.0.1', 'ruby', '4cxE6F1QkY2REFKvrd', 'website'
  end
  return $db_website
end
