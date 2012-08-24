

marker8 = createMarker(-1034.800, 457.39,  14.50, "ring", 17 ,255 ,160 ,0 ,255)
marker7 = createMarker(836.26, -2066.00,  11.30, "cylinder", 34 ,255 ,160 ,0 ,255)
marker6 = createMarker(2049.00, -2382.00,  27.50, "corona", 2 ,255 ,160 ,0 ,255)
marker5 = createMarker(  3.00,  23.00, 1201.00, "corona", 2 ,0 ,0 ,0 ,255)
marker4 = createMarker(2029.68, -2535.34,  61.00, "ring", 3 ,255 ,160 ,0 ,255)
marker3 = createMarker(2399.69, -2535.19, 354.20, "corona", 3 ,255 ,160 ,0 ,255)
marker2 = createMarker(1898.20, -2345.70,  44.20, "corona", 3 ,255 ,160 ,0 ,255)
marker1 = createMarker(2798, -2448, 30, "corona", 2 ,255 ,160 ,0 ,255)


setElementInterior(marker5,1)
setElementDimension(marker5,200)
setMarkerTarget(marker8,-777,708,96)

setElementDimension(marker1, 1)
setElementDimension(marker2,1)
setElementDimension(marker3,1)
setElementDimension(marker4,1)
setElementDimension(marker6,1)
setElementDimension(marker7,1)
setElementDimension(marker8,1)
			



addEventHandler("onClientMarkerHit",root,
    function(target)
        local lol = isPedInVehicle(target)
        local car = getPedOccupiedVehicle(target)
		if source == marker2 then
			if lol == true then
				setElementVelocity(car,  -0.30,  -0.50,   0.70)
			else
				setElementVelocity(target,  -0.30,  -0.50,   0.70)
			end
		end
		if source == marker1 then
		   if lol == true then
				setElementVelocity(car, 0, 1, 0.5)
			else
				setElementVelocity(target, 0, 5, 3)
			end 
		end	
		if source == marker3 then
			local car = getPedOccupiedVehicle(target)
			local x,y, z = getElementVelocity ( car or localPlayer )
			setElementVelocity ( car, x*3, y*3, z*3 )
		end	
		if source == marker4 then
				local car = getPedOccupiedVehicle(target)
				local x,y, z = getElementVelocity ( car ) 
				setElementVelocity ( car, x*4, y*4, z*4 )
		end		
		if source == marker5 then 
			setElementPosition(target,2009.7,-2382.6,27.4,true)
			setElementInterior(target,0)
		end
		if source == marker6 then
			setElementInterior(target,1,2,25.2,1200)
		end
		if source == marker7 then
			local car = getPedOccupiedVehicle(target)
			local tX, tY, tZ =  getVehicleTurnVelocity(car)
			local x,y, z = getElementVelocity ( car ) 
			setElementVelocity ( car, -x, -y, -z )
			outputChatBox('#00c300*That is not good idea to go there....',255,255,255,true)	
			setVehicleTurnVelocity(car,-tX,-tY,-tZ)
			setElementRotation(car,0,0,0)
		end		
		if  source == marker8 then
			local car = getPedOccupiedVehicle(target)
			local x,y, z = getElementVelocity ( car ) 
			setElementVelocity ( car, x*1.6, y*1.6, 1.6)
		end	
	end
)