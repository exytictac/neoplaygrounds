---------------------------------------------------------------------
-- Project: irc
-- Author: MCvarial
-- Contact: mcvarial@gmail.com
-- Version: 1.0.0
-- Date: 31.10.2010
---------------------------------------------------------------------

local server
local channel
local duration = 0
------------------------------------
-- Ads
------------------------------------
addEventHandler("onClientResourceStart",resourceRoot,
	function ()
		triggerServerEvent("onIRCPlayerDelayedJoin",getLocalPlayer())
	end
)
addEvent("showAd",true)
addEventHandler("showAd",root,
	function (serv,chan,duration)
		server = serv
		channel = chan
		addEventHandler("onClientRender",root,drawAd)
		if duration ~= 0 then
			setTimer(function () removeEventHandler("onClientRender",root,drawAd) end,duration*1000,1)
		end
	end
)

function drawAd ()
	dxDrawText("Join the irc @ "..tostring(server).." "..tostring(channel).." (http://npg.comeze.com/irc/)",15,0)
end