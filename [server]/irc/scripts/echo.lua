﻿---------------------------------------------------------------------
-- Project: irc
-- Author: MCvarial
-- Contact: mcvarial@gmail.com
-- Version: 1.0.0
-- Date: 31.10.2010
---------------------------------------------------------------------

------------------------------------
-- Echo
------------------------------------
local messages = {}
local root = getRootElement()
local countryNames = {
    ["AD"]="Andora",
    ["AG"]="Antigua - Barbuda",
    ["AI"]="Anguilla ARBIA",
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
    ["UK"]="United-Kingdom",
    ["US"]="United-States",
	["UY"]="Uruguay",
    ["VN"]="Vietnam",
    ["YE"]="Yemen",
    ["YU"]="Yugoslavia",
    ["ZA"]="South-Africa"
}

addEventHandler("onResourceStart",root,
	function (resource)
		if getResourceInfo(resource,"type") ~= "map" then
			if resource == getThisResource() then	
				outputIRC("Hello people! I'm back, aren't you gonna welcome me?")
			else
				outputIRC("07* Resource '"..getResourceName(resource).."' started!")
			end
		end
		if resource == getThisResource() then
			for i,player in ipairs (getElementsByType("player")) do
				messages[player] = 0
			end
		end
	end
)

addEventHandler("onResourceStop",root,
	function (resource)
		if getResourceInfo(resource,"type") ~= "map" then
			outputIRC("07* Resource '"..(getResourceName(resource) or "?").."' stopped!")
		end
	end
)

addEventHandler("onPlayerJoin",root,
	function ()
		messages[source] = 0
		local country = exports['admin']:getPlayerCountry(source)
		setElementData(source,'Country',country)
		outputIRC('03*** ' .. getPlayerName(source) .. ' joined the game from ' .. countryNames[tostring(country)] )
	end
)

addEventHandler("onPlayerQuit",root,
	function (quit,reason,element)
		messages[source] = nil
		if reason then
			outputIRC("02*** "..getPlayerName(source).." was "..quit.." from the game by "..getPlayerName(element).." ("..reason..")")
		else
			outputIRC("02*** "..getPlayerName(source).." left the game ("..quit..")")
		end
	end
)

addEventHandler("onPlayerChangeNick",root,
	function (oldNick,newNick)
		setTimer(function (player,oldNick)
			local newNick = getPlayerName(player)
			if newNick ~= oldNick then
				outputIRC("13* "..oldNick.." is now known as "..newNick)
			end
		end,100,1,source,oldNick)
	end
)

addEventHandler("onPlayerMute",root,
	function ()
		if mutes[getPlayerSerial(source)] then
			local admin = mutes[getPlayerSerial(source)].admin or "console"
			local reason = mutes[getPlayerSerial(source)].reason
			if reason then
				outputIRC("12* "..getPlayerName(source).." has been muted by "..admin.." ("..reason..")")
			else
				outputIRC("12* "..getPlayerName(source).." has been muted by "..admin.." ("..reason..")")
			end
		else
			outputIRC("12* "..getPlayerName(source).." has been muted")
		end
	end
)

addEventHandler("onPlayerUnmute",root,
	function ()
		outputIRC("12* "..getPlayerName(source).." has been unmuted")
	end
)

addEventHandler("onPlayerChat",root,
	function (message,type)
		messages[source] = messages[source] + 1
		if type == 0 then
			outputIRC("07"..getPlayerName(source)..": "..message)
		elseif type == 1 then
			outputIRC("06* "..getPlayerName(source).." "..message)
		elseif type == 2 then
			outputIRC("07(TEAM)"..getPlayerName(source)..": "..message)
		end
	end
)

addEventHandler("onSettingChange",root,
	function (setting,oldValue,newValue)
		outputIRC("6Setting '"..tostring(setting).."' changed: "..tostring(oldValue).." -> "..tostring(newValue))
	end
)

local bodyparts = {nil,nil,"Torso","Ass","Left Arm","Right Arm","Left Leg","Right Leg","Head"}
local weapons = {}
weapons[19] = "Rockets"
weapons[88] = "Fire"
addEventHandler("onPlayerWasted",root,
	function (ammo,killer,weapon,bodypart)
		if killer then
			if getElementType(killer) == "vehicle" then
				local driver = getVehicleController(killer)
				if driver then
					outputIRC("04* "..getPlayerName(source).." was killed by "..getPlayerName(driver).." in a "..getVehicleName(killer))
				else
					outputIRC("04* "..getPlayerName(source).." was killed by an "..getVehicleName(killer))
				end
			elseif getElementType(killer) == "player" then
				if weapon == 37 then
					if getPedWeapon(killer) ~= 37 then
						weapon = 88
					end
				end
				outputIRC("04* "..getPlayerName(source).." was killed by "..getPlayerName(killer).." ("..(getWeaponNameFromID(weapon) or weapons[weapon] or "?")..")("..bodyparts[bodypart]..")")
			else
				outputIRC("04* "..getPlayerName(source).." died")
			end
		else
			outputIRC("04* "..getPlayerName(source).." died")
		end
	end
)
		
addEvent("onPlayerFinish",true)
addEventHandler("onPlayerFinish",root,
	function (rank,time)
		outputIRC("12* "..getPlayerName(source).." finished (rank: "..rank.." time: "..msToTimeStr(time)..")")
	end
)

addEvent("onGamemodeMapStart",true)
addEventHandler("onGamemodeMapStart",root,
	function (res)
		outputIRC("12* Map started: "..(getResourceInfo(res, "name") or getResourceName(res)))
		local resource = getResourceFromName("mapratings")
		if resource and getResourceState(resource) == "running" and exports.mapratings:getMapRating(getResourceName(res)) and exports.mapratings:getMapRating(getResourceName(res)).average then
			outputIRC("07* Rating: "..exports.mapratings:getMapRating(getResourceName(res)).average)
		end
	end
)

addEvent("onPlayerToptimeImprovement",true)
addEventHandler("onPlayerToptimeImprovement",root,
	function (newPos,newTime,oldPos,oldTime)
		if newPos == 1 then
			outputIRC("07* New record: "..msToTimeStr(newTime).." by "..getPlayerName(source).."!")
		end
	end
)

addEventHandler("onBan",root,
	function (ban)
		outputIRC("12* Ban added by "..(getPlayerName(source) or "Console")..": name: "..(getBanNick(ban) or "/")..", ip: "..(getBanIP(ban) or "/")..", serial: "..(getBanSerial(ban) or "/")..", banned by: "..(getBanAdmin(ban) or "/").." banned for: "..(getBanReason(ban) or "/"))
	end
)

addEventHandler("onUnban",root,
	function (ban)
		outputIRC("12* Ban removed by "..(getPlayerName(source) or "Console")..": name: "..(getBanNick(ban) or "/")..", ip: "..(getBanIP(ban) or "/")..", serial: "..(getBanSerial(ban) or "/")..", banned by: "..(getBanAdmin(ban) or "/").." banned for: "..(getBanReason(ban) or "/"))
	end
)

addEvent("onPlayerRaceWasted")
addEventHandler("onPlayerRaceWasted",root,
	function (vehicle)
		if #getAlivePlayers() == 1 and currentmode ~= "Sprint" then
			outputIRC("12* "..getPlayerName(getAlivePlayers()[1]).." won the deathmatch!")
		end
	end
)

------------------------------------
-- Admin interaction
------------------------------------
addEvent("onPlayerFreeze")
addEventHandler("onPlayerFreeze",root,
	function (state)
		if state then
			outputIRC("12* "..getPlayerName(source).." was frozen!")
		else
			outputIRC("12* "..getPlayerName(source).." was unfrozen!")
		end
	end
)

addEvent("aMessage",true)
addEventHandler("aMessage",root,
	function (Type,t)
		if Type ~= "new" then return end
		
		local channel = ircGetEchoChannel()
		ircRaw(ircGetChannelServer(channel),"NOTICE %"..tostring(ircGetChannelName(channel)).." :New admin message by "..tostring(getPlayerName(source)))
		ircRaw(ircGetChannelServer(channel),"NOTICE %"..tostring(ircGetChannelName(channel)).." :Category: "..tostring(t.category))
		ircRaw(ircGetChannelServer(channel),"NOTICE %"..tostring(ircGetChannelName(channel)).." :Subject: "..tostring(t.subject))
		ircRaw(ircGetChannelServer(channel),"NOTICE %"..tostring(ircGetChannelName(channel)).." :Message: "..tostring(t.message))
	end
)

------------------------------------
-- Votemanager interaction
------------------------------------
local pollTitle

addEvent("onPollStarting")
addEventHandler("onPollStarting",root,
	function (data)
		if data.title then
			pollTitle = tostring(data.title)
		end
	end
)

addEvent("onPollModified")
addEventHandler("onPollModified",root,
	function (data)
		if data.title then
			pollTitle = tostring(data.title)
		end
	end
)

addEvent("onPollStart")
addEventHandler("onPollStart",root,
	function ()
		if pollTitle then
			outputIRC("14* A vote was started ["..tostring(pollTitle).."]")
		end
	end
)

addEvent("onPollStop")
addEventHandler("onPollStop",root,
	function ()
		if pollTitle then
			pollTitle = nil
			outputIRC("14* Vote stopped!")
		end
	end
)

addEvent("onPollEnd")
addEventHandler("onPollEnd",root,
	function ()
		if pollTitle then
			pollTitle = nil
			outputIRC("14* Vote ended!")
		end
	end
)

addEvent("onPollDraw")
addEventHandler("onPollDraw",root,
	function ()
		if pollTitle then
			pollTitle = nil
			outputIRC("14* A draw was reached!")
		end
	end
)