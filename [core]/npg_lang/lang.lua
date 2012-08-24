local languages = {}
local c_lang = "en"

function register_language(lang, tab)
	languages[lang] = tab;
end

function __(str, param1)
	if isClient() then
		c_lang = getElementData(getLocalPlayer(), "language");
		
		if languages[c_lang] then
			return languages[c_lang][str] or str
		end
		return str;
	end
	
	local p_lang = getElementData(param1, "language");
		
	if languages[p_lang] then
		return languages[p_lang][str] or str;
	end
	
	return str;
end

function isClient()
	return triggerServerEvent and true or false
end