if getResourceName(getThisResource()):lower() == "openframe" then
	local script = {}

	function push(str)
		table.insert(script, str)
	end
	
	function scripts()
		return script
	end

	function load()
		return [[
			for i,v in ipairs(exports.openframe:scripts()) do
				loadstring(v)()
			end
		]]
	end
else
	loadstring(exports.openframe:load())()
end