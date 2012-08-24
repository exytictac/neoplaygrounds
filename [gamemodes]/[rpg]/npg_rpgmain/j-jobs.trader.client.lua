--[[
	RPG Jobs v2.0.1 [trader.client]
	
	Made By: JR10
	
	Copyright (c) 2011
]]

local sX, sY = guiGetScreenSize()

addEventHandler('onClientRender', root,
	function()
		local px, py, pz = getElementPosition(getLocalPlayer())
		if getDistanceBetweenPoints2D(2745.2236328125, -2576.4384765625, px, py) <= 17 then
			local x, y = getScreenFromWorldPosition(2745.2236328125, -2576.4384765625, 4)
			if x and y then
				dxDrawFramedText("Teleport to the ship", x, y, x ,y,tocolor(255,255,255,255),2.0,"default","center","center",false,false,false)
			end
		end
		if getDistanceBetweenPoints2D(3044.6176757813, -2627.2993164063, px, py) <= 17 then
			local x, y = getScreenFromWorldPosition(3044.6176757813, -2627.2993164063, 8.9825096130371)
			if x and y then
				dxDrawFramedText("Teleport to the Dock", x, y, x,y,tocolor(255,255,255,255),2.0,"default","center","center",false,false,false)
			end
		end
	end
)

addEventHandler('onClientResourceStart', resourceRoot,
	function()
		createBuyMerchandiseWnd()
	end
)

function createBuyMerchandiseWnd()
	BuyMerchandiseLabel = {}
	local x, y = sX/2 - 395/2, sY/2 - 268/2
	BuyMerchandiseWnd = guiCreateWindow(x, y, 395, 268, 'Buy Merchandise', false)
	guiSetAlpha(BuyMerchandiseWnd,1)
	guiWindowSetSizable(BuyMerchandiseWnd,false)
	BuyMerchandiseLabel[1] = guiCreateLabel(0, 27,394,40,'Type in the ammount of money you want to spend on merchandise',false,BuyMerchandiseWnd)
	guiLabelSetColor(BuyMerchandiseLabel[1],255,255,0)
	guiLabelSetHorizontalAlign(BuyMerchandiseLabel[1],"center",false)
	guiSetFont(BuyMerchandiseLabel[1],"default-bold-small")
	BuyMerchandiseLabel[2] = guiCreateLabel(18, 102,376,46,'   Ammount:',false,BuyMerchandiseWnd)
	guiLabelSetColor(BuyMerchandiseLabel[2],255,0,0)
	guiSetFont(BuyMerchandiseLabel[2],"default-bold-small")
	BuyMerchandiseAmmountEdit = guiCreateEdit(128, 89,246,49,'',false,BuyMerchandiseWnd)
	guiEditSetMaxLength(BuyMerchandiseAmmountEdit,7)
	guiSetProperty(BuyMerchandiseAmmountEdit,"AlwaysOnTop","true")
	BuyMerchandiseB = guiCreateButton(31, 198,138,48,'Buy Merchandise',false,BuyMerchandiseWnd)
	guiSetFont(BuyMerchandiseB,"default-bold-small")
	guiSetProperty(BuyMerchandiseB,"HoverTextColour","FFFFFF00")
	BuyMerchandiseCancelB = guiCreateButton(226, 198,138,48,'Cancel',false,BuyMerchandiseWnd)
	guiSetFont(BuyMerchandiseCancelB,"default-bold-small")
	guiSetProperty(BuyMerchandiseCancelB,"HoverTextColour","FFFF0000")
	guiSetVisible(BuyMerchandiseWnd, false)
	addEventHandler('onClientGUIClick', BuyMerchandiseB, buyMerchandise_C, false)
	addEventHandler('onClientGUIClick', BuyMerchandiseCancelB, buyMerchandiseCancel, false)
end

addEvent('showBuyMerchandiseWnd', true)
addEventHandler('showBuyMerchandiseWnd', root,
	function()
		guiSetVisible(BuyMerchandiseWnd, not guiGetVisible(BuyMerchandiseWnd))
		showCursor(guiGetVisible(BuyMerchandiseWnd))
		guiSetInputMode ( "no_binds_when_editing" )
	end
)

function buyMerchandiseCancel()
	guiSetVisible(BuyMerchandiseWnd, false)
	showCursor(false)
	guiSetInputMode("allow_binds")
end

function buyMerchandise_C()
	local ammount = guiGetText(BuyMerchandiseAmmountEdit)
	if ammount ~= '' and tonumber(ammount) ~= nil and tonumber(ammount) > 0 then
		if tonumber(ammount) <= getPlayerMoney(localPlayer) then
			triggerServerEvent('BuyMerchandise', root, ammount)
			guiSetVisible(BuyMerchandiseWnd, false)
			showCursor(false)
			guiSetInputMode ( "allow_binds" )
		else
			outputChatBox("You are yoo poor")
		end
	else
		outputChatBox('Type in a correct ammount first')
	end
end