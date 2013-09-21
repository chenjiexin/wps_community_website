require 'pathname'

this_script = Pathname.new(__FILE__)

REPO_ROOT = this_script.parent.parent.parent.realpath.to_s
DOCUMENT_ROOT = REPO_ROOT + "/root"
FRAMEWORK_DIR = REPO_ROOT + "/framework"
DATA_DIR = REPO_ROOT + "/data"
VAR_DIR = REPO_ROOT + "/var"

if not $LOAD_PATH.include? FRAMEWORK_DIR
  $LOAD_PATH << FRAMEWORK_DIR
end
