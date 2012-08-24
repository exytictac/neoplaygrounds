
local currentView = 3
local customViews = {
	[0] = true,
	[4] = true,
}

local Modes = {
	[0] = 'Cockpit',
	[1] = 'Bumper view',
	[2] = 'Near view',
	[3] = 'Far behind view',
	[4] = 'Top down',
	[5] = 'Cinematic',
}

local setRealCameraViewMode = setCameraViewMode
local function setCameraViewMode ( id )
	if customViews [ id ] then
		return
	end
	currentView = id
	setRealCameraViewMode ( id )
end

local function changeViewMode ( )

	if currentView == #Modes then
		currentView = -1
	end
	
	setTimer ( function ( )
	
	if getKeyState ( 'v' ) then
		setCameraViewMode ( 3 )
	end
	
	setCameraViewMode ( currentView + 1 )
	while customViews [ currentView ] == true do
		setCameraViewMode ( currentView + 1 )
	end
	
	outputChatBox ( 'Camera mode set to '.. Modes [ currentView ] ..' (' .. currentView .. ')' )
	
	end, 500, 1 )
end

bindKey ( 'v', 'down', changeViewMode )
setControlState ( 'change_camera', false )