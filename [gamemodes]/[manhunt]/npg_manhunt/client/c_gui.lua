local g_Interfaces ={}
function _initGUIs()
	for _,v in pairs(g_Interfaces) do
		v()
	end
end

function _addGui(f)
	table.insert(g_Interfaces,f)
end

-- COUNTDOWN
local msglabel, msgfont, cdid,msganim
local countdownTimers = {}
addEvent('mh:countdown', true)
addEventHandler('mh:countdown', root, function()
		for _,v in pairs(countdownTimers) do
			if isTimer(v) then
				killTimer(v)
			else
				countdownTimers[_] = nil
			end
		end
		
		guiSetSize(msglabel, 1, 0.3, true)
		guiSetPosition(msglabel,0,0, true)
		countdownTimers[5] = setTimer(function()
		msganim = Animation.createAndPlay(msglabel, Animation.presets.guiPulse(600, 2) )
		cdid = 3
		guiSetText(msglabel, '')
		guiSetAlpha(msglabel, 255)
		guiSetVisible(msglabel, true)
		countdownTimers[1] = setTimer(function()
			Animation.createAndPlay(msglabel, Animation.presets.guiFadeIn(350) )
			guiSetText(msglabel, tostring(cdid))
			playSoundFrontEnd(44)
			cdid = cdid - 1
			countdownTimers[2] = setTimer(guiSetText, 500, 1, msglabel, '')
			Animation.createAndPlay(msglabel, Animation.presets.guiFadeOut(550) )
		end, 1000, 3)
		
		countdownTimers[3] = setTimer(function()
			guiSetText(msglabel, 'GO!')
			playSoundFrontEnd(45)
			Animation.createAndPlay(msglabel, Animation.presets.guiFadeOut(2000) )
			
		end, 4000, 1)
		countdownTimers[4] = setTimer(function()
			msganim:remove(msganim)
			guiSetVisible(msglabel, false)
			guiSetSize(msglabel, 1, 0.3, true)
			guiSetPosition(msglabel,0,0, true)
		end, 6500, 1)
		end, 50, 1)
	end
)

function CountdownInterfaceInit( )
	font = guiCreateFont( "BleedingCowboys.ttf", 130 )
	msglabel = guiCreateLabel(0,0,1,0.3,"",true)
	guiLabelSetVerticalAlign(msglabel,"center")
	guiLabelSetHorizontalAlign(msglabel,"center",false)
	guiSetFont(msglabel,font)
	guiSetAlpha(msglabel, 0)
	guiSetVisible(msglabel, false)
end
_addGui(CountdownInterfaceInit)