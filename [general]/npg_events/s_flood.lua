local waterElement
local waterLevel = 0
local waterIncrease = 1
local timer1
local timer2

function message(water)
	outputChatBox("#FF0000[INFO]: #FFFF00"..water, root, 255, 100, 100, true)
end

local messages = {
	[50] = {"The level of water is only 50m, but the fridge is already wet!"},
	[100] = {"The water has reached 100m mark. Go get a boat, fast!", 0.3},
	[250] = {"The water reached 250m mark. Only planes can save you now", 0.7}
}


function decreaseWaterLevel2()
	waterLevel = waterLevel - 1
	setWaterLevel(waterElement, waterLevel)
	
	if (waterLevel == 0) then
		message("The flood is over.")
		if isTimer(timer2) then
			killTimer(timer2)
		end
		
		-- Enable clouds.
		setCloudsEnabled(true)
		
		-- Remove water.
		destroyElement(waterElement)
	end
end

function decreaseWaterLevel1()
	setTimer(decreaseWaterLevel2, 1000, 0)
	setWaveHeight(0)
end

function increaseWaterLevel2()
	waterLevel = waterLevel + waterIncrease
	setWaterLevel(waterElement, waterLevel)
	
	if type(messages[waterLevel]) == "table" then
		message(messages[waterLevel][1])
		if messages[waterLevel][2] then
			waterIncrease = messages[waterLevel][2]
		end
	elseif waterLevel >= 500 and waterLevel >= 501 then
		message("Congrats! The water has stopped rising.")
		if isTimer(timer1) then
			killTimer(timer1)
		end
	
		timer2 = setTimer(decreaseWaterLevel1, 120000, 1)
		
		-- Change the weather.
		setWeatherBlended(0)
	end
end

function increaseWaterLevel1()
	message("Mother Nature is angry at our doings! Lets GTFO, FAST!")
	setTimer(increaseWaterLevel2, 2000, 0)
	setWaveHeight(1)
end

function startFlood()
	local time = getRealTime()
	if time.weekday == 0 then --Sunday
		message("The storm has started and the end is near, Stormtastic Sunday is definitely here!")

		-- Change the weather and disable clouds.
		setWeatherBlended(8)
		setCloudsEnabled(false)

		-- Create the water.
		waterElement = createWater(-3000, -3000, 0, 3000, -3000, 0, -3000, 3000, 0, 3000, 3000, 0)
		
		-- Set initial water level.
		setWaterLevel(waterElement, 0)
		
		-- Set wave height.
		setWaveHeight(0)

		timer1 = setTimer(increaseWaterLevel1, 120000, 1)
	end
end

startFlood()
setTimer(startFlood, 14400000, 0)