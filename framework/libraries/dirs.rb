require 'pathname'

this_script = Pathname.new(__FILE__)

REPO_ROOT = this_script.parent.parent.parent.realpath.to_s
DOCUMENT_ROOT = REPO_ROOT + "/root"
DATA_DIR = REPO_ROOT + "/data"

