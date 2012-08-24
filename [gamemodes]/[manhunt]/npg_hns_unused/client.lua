addEvent("onClientPlayerSelectGamemode", true)
addEventHandler("onClientPlayerSelectGamemode", me, function(gm)
		if gm~="manhunt" then return end
		outputChatBox("Welcome to #ff0000Manhunt", 0,255,0,true)
		fadeCamera(false)
		setTimer(triggerServerEvent, 500, 1, "onManhuntPlayerStart", me)
		showChat(true)
		showCursor(false)
	end
)