local script = [[
	local delete = { %s }
	
	addEventHandler( "on"..((triggerServerEvent and 'Client') or '')..'"ResourceStart", getResourceRootElement(), function()
			for _,v in ipairs(delete) do
				removeWorldModel(v)
			end
		end
	)
]]

------------------------------------------------------------------------------
-- fileSetContents() function by qaisjp                                     --
-- This function can be used within any resource as long as credit is given --
-- You may modify this function to your requirements                        --
------------------------------------------------------------------------------
local function fileSetContents(file, ...)
	if fileExists(file) then
		fileDelete(file)
	end
	file = fileCreate(file)
	fileWrite(file, ...)
	fileClose(file)
end
addEvent('worldel:file', true)
addEventHandler('worldel:file', root, function(tab)
		local input = table.concat(tab, ', ')
		local script = script:format(input)
		fileSetContents('script.lua', script)
	end
)