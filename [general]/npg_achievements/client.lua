localPlayer = getLocalPlayer ()
achievment = nil
pts = nil

function showAchUnlockedMsg ( achievement, points, sound )
	pts = points
	addEventHandler("onClientRender",root, createDXMsg )

	setTimer (
	function ()
		removeEventHandler ( "onClientRender",root, createDXMsg )
	end, 3500, 1 )
	if sound == 1 then
		playSound("achopen.mp3") --Play wasted.mp3 from the sounds folder
		setSoundVolume(sound, 3) -- set the sound volume to 50%
	end

end

addEvent( "showAchUnlcokedMsgS", true )
addEventHandler( "showAchUnlcokedMsgS", getRootElement(), showAchUnlockedMsg )

function givePlayerAchC ( achievement , points, number )
	if getElementData ( localPlayer, "achievements"..tostring(number).."" ) == 0 then 
		showAchUnlcokedMsg ( achievement, points )
		setElementData ( localPlayer, "achievements"..tostring(number).."", 1 )
		setElementData ( localPlayer, "points", getElementData ( localPlayer, "points" ) + points )
	end 
end


		

function createDXMsg ( )
    dxDrawText( ""..tostring(pts).."p",487.0,677.0,576.0,742.0,tocolor(255,255,255,255),2.0,"pricedown","left","top",false,false,true)
    dxDrawText( achievment,591.0,715.0,917.0,742.0,tocolor(255,255,255,255),2.0,"arial","left","top",false,false,true)
    dxDrawText("Achievment unlocked",593.0,676.0,913.0,712.0,tocolor(255,255,255,255),2.5,"sans","left","top",false,false,true)
    dxDrawRectangle(477.0,667.0,463.0,86.0,tocolor(0,0,0,200),false)
end