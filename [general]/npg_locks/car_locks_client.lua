addEvent ( "onPlaySoundNearElement", true )
addEventHandler ( "onPlaySoundNearElement", getRootElement(), 
	function(theElement, sound)
		local maxdist = 15.0
		if ( theElement ) then
			local x,y,z = getElementPosition(theElement)
			local x2,y2,z2 = getElementPosition(getLocalPlayer())
			local dist = getDistanceBetweenPoints3D ( x, y, z, x2, y2, z2 ) 
			if ( dist < maxdist ) then
				playSoundFrontEnd ( 5 )
			end
		end
	end
)
