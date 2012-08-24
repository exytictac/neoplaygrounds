


-- Ignore me: http://imgchili.com/show/4366/4366910_1326227850_16735.jpg



local leveltop = 0
local me = getLocalPlayer()
local freezeTimer = nil
local thePlayerLevel = "-"
local scoreLabel
local sWidth, sHeight = guiGetScreenSize()
local smallWidth, smallHeight =  800, 600

	instructions = guiCreateLabel ( 0, 0.2, 1, 0.5, "Reach the top of the Haystack!", true )
	guiSetFont ( instructions, "sa-gothic" )
	guiLabelSetColor ( instructions, 255, 255, 255 )
	guiLabelSetHorizontalAlign ( instructions, "center", false )
	setTimer ( destroyElement, 5000, 1, instructions )


	hayWindow = guiCreateStaticImage(0.2525,0.02,0.465,0.0917,"tutorial.png",true)
	label_info = guiCreateLabel(0.0215,0.3636,0.9624,0.4909,"You are at the bottom! Get to the top!",true,hayWindow)
	guiLabelSetVerticalAlign(label_info,"center")
	guiLabelSetHorizontalAlign(label_info,"center",false)
	guiLabelSetColor ( label_info, 0, 0, 0 )
	guiSetFont ( label_info, "default-bold-small" )
	
	pge = true

	label_mylevelnot = guiCreateLabel(0.785,0.0617,0.0625,0.0317,"Level",true)
	guiLabelSetHorizontalAlign(label_mylevelnot,"center",false)
	

	label_mylevel = guiCreateLabel(0.7825,0.0933,0.0625,0.1033,"-",true)
	guiLabelSetVerticalAlign(label_mylevel,"center")
	guiLabelSetHorizontalAlign(label_mylevel,"center",false)
	guiSetFont(label_mylevel,"sa-gothic")

	label_leader = guiCreateLabel(0.7962,0.0083,0.1937,0.0367,"Leader: -",true)
	

	player_grid = guiCreateGridList(0.7788,0.2833,0.22,0.465,true)
	guiSetAlpha(player_grid,0)
	guiGridListSetSelectionMode(player_grid,2)
	guiGridListAddColumn(player_grid,"Player",0.2)
	guiGridListAddColumn(player_grid,"Level",0.2)

	
	guiSetVisible(hayWindow,false)
	guiSetVisible(player_grid,false)
	guiSetVisible(label_mylevel,false)
	guiSetVisible(label_mylevelnot,false)
	guiSetVisible(label_leader,false)
	guiSetVisible(instructions,false)

function levelManagement(dataName)
	if getElementData(source, "minigame") and (getElementType(source) == "player") and (dataName == "hay:currentlevel") then
		local maxLevelPlayers = {}
		local maxLevel = 0
		for k,v in ipairs(getElementsByType( "player" )) do
			level = tonumber(getElementData ( v, "hay:currentlevel" )) or 0
			if level >= maxLevel then
				maxLevel = level
				maxLevelPlayers = {}
				table.insert ( maxLevelPlayers, getPlayerName(v) )
			elseif level == maxLevel then
				table.insert ( maxLevelPlayers, getPlayerName(v) )
			end
		end
		local leadertext, playerlevel
		if #maxLevelPlayers == 1 then
			leadertext = "Leader: "..maxLevelPlayers[1].." ("..maxLevel..")"
		elseif #maxLevelPlayers < 4 then
			leadertext = "Leaders: "..table.concat(maxLevelPlayers,",").." ("..maxLevel..")"
		else
			leadertext = "Leader: - (" ..maxLevel.. ")"
		end
		playerLevel = tonumber(getElementData(me,"hay:currentlevel")) or 0
		guiSetText ( label_leader, leadertext )
		guiSetText ( label_mylevel, tostring(playerLevel) )
		
		if (playerLevel ~= nil) and (playerLevel ~= false) and (playerLevel ~= true) then
			if playerLevel <= 2 then
				guiSetText(label_info, "You are at the bottom! Get to the top!")
			elseif playerLevel >= 6 and playerLevel <= 8 then
				guiSetText(label_info, "Peh! That's easy, I can do it again and again.")
			elseif playerLevel >= 15 and playerLevel <= 18 then
				guiSetText(label_info, "There is still a long way, but you are getting there.")
			elseif type(playerLevel) ~= "number" then
				guiSetText(label_info, "You are at the bottom! Get to the top!")
			end
			
			if playerLevel == 1 then
				setElementData(me, "hay:timetaken",0, true)
				startTimeTaken = getTickCount()
			elseif playerLevel == 0 then
				setElementData(me, "hay:timetaken",false, true)
				startTimeTaken = getTickCount()
			end
		end
	end
end

function stuff()
	if getElementData(me, "minigame") then
		setWeather(1)
		setTime(12, 0)
		setCloudsEnabled(false)
	
		local _, _, z = getElementPosition(me)

		thePlayerlevel = math.floor(z  / 3 - 0.5)

		if thePlayerlevel >= 42 then
			setElementData ( me, "hay:currentlevel", "-", true )
		else
			if thePlayerlevel > leveltop then
				leveltop = thePlayerlevel
			end
			if getElementData(me,"hay:currentlevel") ~= tostring(thePlayerlevel) then
				setElementData(me, "hay:currentlevel", thePlayerlevel,true)
			end
		end
		
		setElementData(me, "hay:timetaken", (getTickCount()-startTimeTaken), true)
	end
end


local k = 0
function guiHandler()
	if guiGetVisible(hayWindow) and getElementData(me, "minigame") then
		guiSetVisible(hayWindow,false)
		guiSetVisible(player_grid,false)
		guiSetVisible(label_mylevel,false)
		guiSetVisible(label_mylevelnot,false)
		guiSetVisible(label_leader,false)
	else
		guiSetVisible(hayWindow,true)
		guiSetVisible(player_grid,true)
		guiSetVisible(label_mylevel,true)
		guiSetVisible(label_mylevelnot,true)
		guiSetVisible(label_leader,true)
		instructions = guiCreateLabel ( 0, 0.2, 1, 0.5, "Reach the top of the Haystack!", true )
		guiSetFont ( instructions, "sa-gothic" )
		guiLabelSetColor ( instructions, 255, 255, 255 )
		guiLabelSetHorizontalAlign ( instructions, "center", false )
		setTimer ( destroyElement, 5000, 1, instructions )
	end
end




addEvent("hay:client", true)
addEventHandler("hay:client", root,
	function(prepare)
		if prepare == "join" then
			startTimeTaken = getTickCount()
			guiHandler()
			addEventHandler ( "onClientElementDataChange",root,levelManagement )
			addEventHandler("onClientRender", root, stuff)
		elseif prepare == "leave" then 
			guiHandler()
			removeEventHandler("onClientElementDataChange", root, levelManagement)
			removeEventHandler("onClientRender", root, stuff)
		end
	end
)



