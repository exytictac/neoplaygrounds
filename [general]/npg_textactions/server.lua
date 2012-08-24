function sendMessage(thePlayer, text, r, g, b, formattable)
	if isElement(thePlayer) and getElementType(thePlayer) == "player" then
		triggerClientEvent(thePlayer, "noticeBoard:send", thePlayer, text, r, g, b, formattable)
	end
end

function sendGlobalMessage(text, r, g, b, formattable)
	for i,v in pairs(getElementsByType("player")) do
		triggerClientEvent(v, "noticeBoard:send", v, text, r, g, b, formattable)
	end
end

local countryNames = {
    ["AD"]="Andorra",
    ["AG"]="Antigua - Barbuda",
    ["AI"]="Anguilla Arabia",
	["AL"]="Albania",
    ["AM"]="Armenia",
    ["AR"]="Argentina",
    ["AT"]="Austria",
    ["AU"]="Australia",
	["AW"]="Aruba",
	["BA"]="Bosnia",
	["BE"]="Belgium",
    ["BG"]="Bulgaria",
	["BH"]="Bahrain",
	["BM"]="Bermuda",
    ["BN"]="Bronei ",
    ["BO"]="Bolivia",
	["BR"]="Brazil",
    ["BS"]="Bahamas",
    ["BW"]="Botswana",
    ["BY"]="Belarus",
	["BZ"]="Belize",
    ["CA"]="Canada",
    ["CC"]="Cocos",
	["CH"]="Switzerland",
    ["CI"]="Ivory Coast",
	["CL"]="Chile",
    ["CN"]="China",
	["CO"]="Colombia",
	["CU"]="Cuba",
	["CY"]="Cyprus",
    ["CZ"]="Czech",
    ["DE"]="Germany",
    ["DK"]="Denmark",
    ["DM"]="Dominica",
	["DO"]="Dominican",
    ["EC"]="Ecuador",
	["EE"]="Estonia",
    ["EG"]="Egypt",
    ["ES"]="Spain",
    ["ET"]="Ethiopia",
    ["FI"]="Finland",
	["FR"]="France",
    ["GB"]="Great-Britain",
    ["GL"]="Greenland",
    ["GY"]="Guyana",
    ["HR"]="Croatia",
	["HU"]="Hungary",
    ["ID"]="Indonesia",
    ["IE"]="Ireland",
    ["IR"]="Iran",
	["IS"]="Iceland",
    ["IT"]="Italy",
	["IN"]="India",
	["JO"]="Jordan",
	["JM"]="Jamaica",
    ["jp"]="Mexico",
    ["KW"]="Kuwait",
	["IT"]="Italy",
    ["LU"]="Luxembourg",
    ["LV"]="Latvia",
	["MA"]="Morocco",
    ["MC"]="Monaco",
    ["MT"]="Malta",
    ["MX"]="Mexico",
    ["NG"]="Nigeria",
	["NL"]="Netherlands",
    ["NO"]="Norway",
	["PA"]="Panama",
    ["PE"]="Peru",
    ["PH"]="Philipines",
	["PK"]="Pakistan",
    ["PL"]="Poland",
    ["PT"]="Portugal",
    ["QA"]="Qatar",
	["RO"]="Romania",
    ["RU"]="Russia",
    ["SA"]="Saudi Arbia",
	["SE"]="Sweden",
    ["SI"]="Slovania",
    ["TO"]="Tonga",
    ["TR"]="Turkey",
    ["UA"]="Ukraine",
    ["UK"]="United Kingdom",
    ["US"]="United States",
	["UY"]="Uruguay",
    ["VN"]="Vietnam",
    ["YE"]="Yemen",
    ["YU"]="Yugoslavia",
    ["ZA"]="South Africa",
	["TN"]="Tunis"
}

function onJoin()
    local country = exports['admin']:getPlayerCountry(source);
	setmetatable ( { theCountry = country or 'N/A' }, countryNames );
		if ( countryNames [ country ] ) then
			triggerClientEvent('noticeBoard:send', root, "* "..getPlayerName ( source ).. " has joined the game from ".. countryNames [ country ], 255, 100, 100)
		end
end
addEventHandler ( "onPlayerJoin", getRootElement(), onJoin )


function onQuit(reason)
    triggerClientEvent('noticeBoard:send', root, "* "..getPlayerName ( source ).. " has left the game ("..reason..")", 255, 100, 100)
end
addEventHandler ( "onPlayerQuit", getRootElement(), onQuit )


function onLogin( )
	sendMessage ( source, "* You logged in sucessfully.", 0, 255, 0, false )
end
addEventHandler ( "onPlayerLogin", root, onLogin )

function onNickChange ( old, new )
  triggerClientEvent ( 'noticeBoard:send', root, "*"..old.. " is now known as "..new, 255, 100, 100  )
end
addEventHandler ( "onPlayerChangeNick", root, onNickChange )

function onGamemodeEnter(gm)
	triggerClientEvent ( 'noticeBoard:send', root,"* "..getPlayerName(source).." has joined "..gm  )
end
addEvent("onPlayerSelectGamemode", true)
addEventHandler("onPlayerSelectGamemode", root, onGamemodeEnter)
	
