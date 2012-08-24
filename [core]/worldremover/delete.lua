---------------------------------------------
-- Delete world element resource by qaisjp --
---------------------------------------------

local removed = {}
deleting = false
local function onClick(b,s,_,_,_,_,_,element)
	if b~='left' or s~='down' then return end
	if element then
		outputChatBox('This element is a MTA element, not world element')
	end
	
	local model, lod = getPointedWorldElementID()
	model, lod = tonumber(model), tonumber(lod)

	if model and removeWorldModel(model, 0, 0, 0, 3000) then
		table.insert(removed, model)
	else
		outputChatBox('Failed on removing world model')
	end
	
	if lod and removeWorldModel(lod, 0, 0, 0, 3000) then
		table.insert(removed, lod)
	else
		outputChatBox('Failed on removing lod')
	end
end


local function startDeleting()
	deleting = not deleting
	setCamera()
	if not deleting then
		removeEventHandler('onClientClick', root, onClick)
		outputChatBox('Type /delcreate to create your script')
		showCursor(false)
		restoreAllWorldModels()
		return
	end
	showCursor(true)
	addEventHandler('onClientClick', root, onClick)
end
addCommandHandler('delete', startDeleting)

local function createScript()
	if #removed == 0 then
		outputChatBox('You nub, y u no remove any world objects?')
		return
	end
	triggerServerEvent('worldel:file', localPlayer, removed)
end
addCommandHandler('delcreate', createScript)

local function undo()
	if #removed == 0 then
		outputChatBox('You nub, whatya gonna undo if theres nothing to undo? -.-')
		return
	end
	restoreWorldModel( removed[#removed], 0, 0, 0, 3000 )
	table.remove(removed)
	outputChatBox('undone!')
end
addCommandHandler('undo', undo)

------------------------------------------------------------------------------
-- getPointedWorldElementID() function by qaisjp                            --
-- This function can be used within any resource as long as credit is given --
-- You may modify this function to your requirements                        --
------------------------------------------------------------------------------
function getPointedWorldElementID()
	local camX, camY, camZ, endX, endY, endZ = getCameraMatrix()
	
	-- get collision point on the line
	local surfaceFound, _,_,_, targetElement,
		_,_,_,_,_,_,modelId,_,_,_,_,_,_,lodId = processLineOfSight(
			camX, camY, camZ, endX, endY, endZ, true, true, true, true, true, true, false, true, localPlaeyr, true
		)
		
	if (not surfaceFound) then 
		outputChatBox('Couldn\'t find surface')
		return
	end
	
	if targetElement then
		outputChatBox('This element is a MTA element, not world element')
		return
	end
	
	return modelId, lodId
end