function is_dir(path)
	local x = lighty.stat(path)
	return x and lighty.stat(path).is_dir
end

function is_file(path)
	local x = lighty.stat(path)
	return x and lighty.stat(path).is_file
end

function rewrite(path)
	local path = string.gsub(path, "//", "/")
	lighty.env["physical.path"] = path
end

function redirect(path)
	lighty.header["Location"] = path
	return 301
end

-- ininialize variants
domain = lighty.env["uri.authority"]
request_uri = lighty.env["physical.path"]
document_root = lighty.env["physical.doc-root"]
path_raw = lighty.env["uri.path-raw"]
request_uri = string.gsub(request_uri, "/$", "")

-- domain redirect
if domain then
	domain = string.gsub(domain, "kso[-]community", "wps-community")
	domain = string.gsub(domain, "wps[-]community[.]com", "wps-community.org")
	domain = string.gsub(domain, "www[.]wps[-]community[.]org", "wps-community.org")
end

if domain ~= lighty.env["uri.authority"] then
	return redirect(lighty.env["uri.scheme"] .. "://" .. domain .. path_raw)
end

-- deal directory
if is_dir(request_uri) then
	if not string.find(path_raw, "/$") then
		return redirect(lighty.env["uri.scheme"] .. "://" .. lighty.env["uri.authority"] .. path_raw .. "/")
	elseif is_file(request_uri .. "/index.html") then
		rewrite(request_uri .. "/index.html")
		return
	elseif is_file(request_uri .. "/index.htm") then
		rewrite(request_uri .. "/index.htm")
		return
	elseif is_file(request_uri .. "/index.php") then
		rewrite(request_uri .. "/index.php")
		return
	elseif is_file(request_uri .. "/index.rb") then
		rewrite(request_uri .. "/index.rb")
		return
	else
		rewrite(document_root .. "/../framework/dircgi.rb")
		return
	end
end

-- rewrite if not file
if not is_file(request_uri) then
	x = string.gsub(request_uri, ".html$", ".rb")
	if is_file(x) then
		rewrite(x)
		return
	end
	x = request_uri .. ".rb"
	if is_file(x) then
		rewrite(x)
		return
	end
end

