local playerInfo = {}
local teamsInfo = {
	['Red'] = {
		id=1,
		colour = {r=255,g=0,b=0},
		skin = 0,
		control = 0
	},
	['Green'] = {
		id=2,
		colour = {r=0,g=255,b=0},
		skin = 1,
		control = 0
	},
	['Blue'] = {
		id=3,
		colour = {r=0,g=255,b=255},
		skin = 2,
		control = 0
	}
}

local teams = {'Red','Green','Blue'}
function getTeamID(n)
	return teams[n]
end
	

local sx,sy = guiGetScreenSize()
local scale = math.min( (0.9+(math.max(sx,sy) - 640) /1280) * 0.1, 1)

local spawn = {
	gui = {},

	position = {1685.7314453125, -2334.2734375, 13.546875},

	currentTeam = 1,
}


addEventHandler("onClientPlayerSelectGamemode", root,
	function(gm)
		if gm~='king of the hill' then return end

		showPlayerHudComponent("clock", false)
		showPlayerHudComponent("vehicle_name", false)
		showPlayerHudComponent("area_name", false)	
		showPlayerHudComponent("radar", false)
		
		prepareTeamSelection()
		calculateScoreDimensions()
		updateSpawnScreen('create')
		
		addEventHandler('onClientRender', root, drawScores)
	end
)
	

function prepareTeamSelection()

	spawn.gui.spawnButton = guiCreateButton((sx/2)-50, sy-220, 100, 20, "Spawn", false)
	spawn.gui.spectateButton = guiCreateButton((sx/2)-50, sy-200, 100, 20, "Spectate", false)
	
	spawn.gui.backButton = guiCreateStaticImage((sx/2)-57-130, sy - 220 - 15, 57, 70, "images/left.png", false)	
	spawn.gui.nextButton = guiCreateStaticImage((sx/2)+130, sy - 220 - 15, 57, 70, "images/right.png", false)	
	
	spawn.ped = createPed(teamsInfo['Red'].skin, unpack(spawn.position))
	setElementDimension(spawn.ped, 200)
	
	addEventHandler("onClientGUIClick", spawn.gui.spawnButton, attemptSpawn, false)
	addEventHandler("onClientGUIClick", spawn.gui.nextButton, changeSpawnSelection, false)
	addEventHandler("onClientGUIClick", spawn.gui.backButton, changeSpawnSelection, false)
	
	addEventHandler("onClientMouseEnter", spawn.gui.nextButton, rolloverImage, false)
	addEventHandler("onClientMouseEnter", spawn.gui.backButton, rolloverImage, false)
	addEventHandler("onClientMouseLeave", spawn.gui.nextButton, rolloverImage, false)
	addEventHandler("onClientMouseLeave", spawn.gui.backButton, rolloverImage, false)	
	
	showSpawnInterfaces(false)
end


function rolloverImage()
	if source == spawn.gui.nextButton then
		guiStaticImageLoadImage(spawn.gui.nextButton, "images/right" .. (spawn.gui.rolloverRight and "" or "Hover") .. ".png")
		spawn.gui.rolloverRight = not spawn.gui.rolloverRight
	elseif source == spawn.gui.backButton then
		guiStaticImageLoadImage(spawn.gui.backButton, "images/left" .. (spawn.gui.rolloverLeft and "" or "Hover") .. ".png")
		spawn.gui.rolloverLeft = not spawn.gui.rolloverLeft
	end
end


function showSpawnInterfaces(toggle)
	guiSetVisible(spawn.gui.spawnButton, toggle)
	guiSetVisible(spawn.gui.spectateButton, toggle)
	guiSetVisible(spawn.gui.nextButton, toggle)
	guiSetVisible(spawn.gui.backButton, toggle)
end

function updateSpawnScreen(type)
	if type == 'create' then
		guiSetInputEnabled(false)
		
		showSpawnInterfaces(true)

		bindKey("arrow_l", "down", changeSpawnSelection, -1)
		bindKey("arrow_r", "down", changeSpawnSelection, 1)
		bindKey("enter", "down", attemptSpawn)

		showCursor(true)
		
		addEventHandler('onClientRender', root, updateSpawnScreen)
	elseif type == 'close' then
		unbindKey('arrow_l', 'down', changeSpawnSelection, -1)
		unbindKey('arrow_r', 'down', changeSpawnSelection, 1)
		unbindKey('enter', 'down', attemptSpawn)
		showCursor(false)
		
		showSpawnInterfaces(false)

	elseif type=='skin' then
		setPedSkin(spawn.ped, teamsInfo[teams[spawn.currentTeam]].skin)
	else
		dxDrawText(teams[spawn.currentTeam], 10, sy+(-170*scale), sx-10, sy, tocolor( teamsInfo[teams[spawn.currentTeam]].colour.r, teamsInfo[teams[spawn.currentTeam]].colour.g, teamsInfo[teams[spawn.currentTeam]].colour.b, 255), scale, 'default', 'left', 'top', true, true, false)
	end
end


function changeSpawnSelection(button, state, dir)	
	if (button == "left" and state == "up") then
		if source == spawn.gui.nextButton then
			dir = 1
		elseif source == spawn.gui.backButton then
			dir = -1
		end
	end
	
	if (button == "left" and state == "up") or (button:find("arrow")) then
        if spawn.currentTeam + dir == 0 then
        	spawn.currentTeam = #teams
        elseif spawn.currentTeam + dir > #teams then
        	spawn.currentTeam = 1
        else
        	spawn.currentTeam = spawn.currentTeam + dir
        end
        updateSpawnScreen('skin')
    end
end


function attemptSpawn(button,state)
	if (button == "left" and state == "up") or button == "enter" or button == "lshift" then
		triggerServerEvent("koth:setTeam", localPlayer, spawn.currentTeam)
	end
end

function resetSettings()
	teamsInfo['Red'].control=0
	teamsInfo['Green'].control=0
	teamsInfo['Blue'].control=0
end  
addEvent("koth:reset", true)
addEventHandler("koth:reset", root, resetSettings)

--------------------------------------------------------------------------------------------------------------
-- Team Scores
--------------------------------------------------------------------------------------------------------------

local scoreDimensions = {
	x = 10,
	y = 400,
	xGap = 10,
	yGap = 5,
	height = 15,
	width = 40,
	teamWidth = 0,
	blockHeight = 0,
	blockWidth = 0,
}

function drawScores()
	dxDrawRectangle(scoreDimensions.x,
					scoreDimensions.y,
					scoreDimensions.blockWidth,
					scoreDimensions.blockHeight,
					tocolor(0, 0, 0, 100), false)
	-- first column				
	dxDrawLine(scoreDimensions.x + scoreDimensions.xGap + scoreDimensions.teamWidth + (scoreDimensions.xGap/2),
				scoreDimensions.y + (scoreDimensions.yGap/2),
				scoreDimensions.x + scoreDimensions.xGap + scoreDimensions.teamWidth + (scoreDimensions.xGap/2),
				scoreDimensions.y + scoreDimensions.blockHeight - (scoreDimensions.yGap/2),
				tocolor(255, 255, 255, 120), 1, false)
	
	-- last row				
	dxDrawLine(scoreDimensions.x + scoreDimensions.xGap + scoreDimensions.teamWidth + (scoreDimensions.xGap/2),
				scoreDimensions.y + scoreDimensions.blockHeight - (scoreDimensions.yGap/2),
				scoreDimensions.x + scoreDimensions.xGap + scoreDimensions.teamWidth + (scoreDimensions.xGap/2),
				scoreDimensions.y + scoreDimensions.blockHeight - (scoreDimensions.yGap/2),
				tocolor(255, 255, 255, 120), 1, false)
				
	dxDrawText("Control",scoreDimensions.x + (scoreDimensions.xGap*2) + scoreDimensions.teamWidth,
		scoreDimensions.y + scoreDimensions.yGap,
		scoreDimensions.x + (scoreDimensions.xGap*2) + scoreDimensions.teamWidth + scoreDimensions.width,
		scoreDimensions.y + scoreDimensions.height + scoreDimensions.yGap,
		tocolor(255, 255, 255, 255), 1, "default", "center", "center", false, false, false
	)						
	
	for teamName,team in pairs(teamsInfo) do
		local i = team.id
		dxDrawLine(scoreDimensions.x + (scoreDimensions.xGap/2),
			scoreDimensions.y + (i*scoreDimensions.height) + (i*scoreDimensions.yGap),
			scoreDimensions.x + scoreDimensions.blockWidth - (scoreDimensions.xGap/2),
			scoreDimensions.y + (i*scoreDimensions.height) + (i*scoreDimensions.yGap),
			tocolor(255, 255, 255, 120), 1, false )
				
	
		dxDrawText(teamName,
			scoreDimensions.x + scoreDimensions.xGap,
			scoreDimensions.y + (i*scoreDimensions.height) + (i*scoreDimensions.yGap) + (scoreDimensions.yGap/2),
			scoreDimensions.x + scoreDimensions.xGap + scoreDimensions.teamWidth,
			scoreDimensions.y + (i*scoreDimensions.height) + (i*scoreDimensions.yGap) + (scoreDimensions.yGap/2) + scoreDimensions.height,
			tocolor(team.colour.r, team.colour.g, team.colour.b, 255), 1, "default-bold", "center", "center", false, false, false)

		dxDrawText(tostring(team.control or 0)..'%',
			scoreDimensions.x + (scoreDimensions.xGap*2) + scoreDimensions.teamWidth,
			scoreDimensions.y + (i*scoreDimensions.height) + (i*scoreDimensions.yGap) + (scoreDimensions.yGap/2),
			scoreDimensions.x + (scoreDimensions.xGap*2) + scoreDimensions.teamWidth + scoreDimensions.width,
			scoreDimensions.y + (i*scoreDimensions.height) + (i*scoreDimensions.yGap) + (scoreDimensions.yGap/2) + scoreDimensions.height,
			tocolor(team.colour.r, team.colour.g, team.colour.b, 255), 1, "default-bold", "center", "center", false, false, false
		)
	end
end

function calculateScoreDimensions()
	scoreDimensions.teamWidth = 0
	
	for i,team in pairs(teamsInfo) do
		local len = dxGetTextWidth(i, 1, "default-bold")
		
		if len > scoreDimensions.teamWidth then
			scoreDimensions.teamWidth = len
		end
	end
	
	scoreDimensions.blockHeight = (#teams * (scoreDimensions.height + scoreDimensions.yGap)) + (scoreDimensions.yGap*2) + scoreDimensions.height
	scoreDimensions.blockWidth = scoreDimensions.teamWidth+(scoreDimensions.xGap*2) + scoreDimensions.width + scoreDimensions.xGap

	scoreDimensions.x = sx - scoreDimensions.blockWidth - 10
	scoreDimensions.y = sy - scoreDimensions.blockHeight - 40
end


addEventHandler("onClientElementDataChange", root,
	function(data, oldValue)
		if (getElementType(source) ~= 'team') or (not getTeamName(source):find('koth')) or data~='koth:control' then return end
		local name = getTeamName(source):gsub('koth:', ''):gsub("^(%a)", string.upper)
		teamsInfo[name].control = getElementData(source, data)
	end
)


addEventHandler("onClientPlayerDamage", localPlayer,
	function()
		if playerInfo.spawnTick then
			if playerInfo.spawnTick > (getTickCount() - 5000) then
				cancelEvent()
			else
				playerInfo.spawnTick = nil
			end
			return
		end
	end
)


addEventHandler("onClientPlayerWasted", localPlayer,
	function()
		if playerInfo.spawnTick then
			if playerInfo.spawnTick > (getTickCount() - 5000) then
				cancelEvent()
			else
				playerInfo.spawnTick = nil
			end
			return
		end
		setGameSpeed(0.2)
	end
)


addEventHandler("onClientPlayerWasted", root,
	function()
		setElementCollisionsEnabled(source, false)
	end
)

addEventHandler("onClientPlayerSpawn", root,
	function()
		setElementCollisionsEnabled(source, true)
	end
)


addEventHandler("onClientPlayerSpawn", localPlayer,
	function(team)
		setGameSpeed(1)
		
		playerInfo.spawnTick = getTickCount()
	end
)



function chokeProtection()
		if playerInfo.spawnTick then
			if playerInfo.spawnTick > (getTickCount() - 5000) then
				cancelEvent()
			else
				playerInfo.spawnTick = nil
			end
		end
	end
 addEventHandler("onClientPlayerChoke", root, chokeProtection)
