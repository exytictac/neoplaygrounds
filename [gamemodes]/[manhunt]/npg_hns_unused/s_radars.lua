-- Creates radar areas, and handles them accordingly, also handles spawns
local cr = createRadarArea
radarAreas = createElement("mh.radarAreas")
spawnAreas = {
	["Countryside"] = {-533, -187, 79},
	["San Fierro"] = {-2719, 377, 5},
	["Bayside"] = {-2615, 2259, 9},
	["Desert"] = {-262, 2586, 64},
	["Las Venturas"] = {2137, 1484, 11},
	["Los Santos"] = {1264, -2024, 60}
}
local spawnNode = xmlLoadFile(SPAWN_FILE)

function initRadarAreas()
	-- Las Venturas
	local lv = cr( 784, 2984, 2200, -2400, 0, 255, 0, 120 )
	setElementData(lv, "area", "Las Venturas", false)
	setElementParent(lv, radarAreas)
	
	-- Desert
	local d  = cr(-1876, 2957, 2600, -1400, 200, 0, 200, 120)
	local d2 = cr(-1239, 1562, 1965, -1000, 200, 0, 200, 120)
	setElementParent(d, radarAreas)
	setElementParent(d2, radarAreas)
	setElementData(d , "area", "Desert", false)
	setElementData(d2, "area", "Desert", false)
	
	-- San Fierro
	local sf = cr( -2970, 1451, 1700, -2400, 200, 200, 0, 120)
	setElementParent(sf, radarAreas)
	setElementData(sf, "area", "San Fierro", false)
	
	-- Bayside
	local bs = cr( -2917, 2924, 900, -900, 200, 0, 0, 120 )
	setElementParent(bs, radarAreas)
	setElementData(bs, "area", "Bayside", false)
	
	-- Countryside
	local cs  = cr(-2939, -1210, 3000, -1700, 0, 0, 200, 120)
	local cs2 = cr(-868, 514, 3800, -1200, 0, 0, 200, 120)
	local cs3 = cr( -868, -689, 925, -520, 0, 0, 200, 120) 
	setElementParent(cs,radarAreas)
	setElementParent(cs2,radarAreas)
	setElementParent(cs3,radarAreas)
	setElementData(cs , "area", "Countryside", false)
	setElementData(cs2, "area", "Countryside", false)
	setElementData(cs3, "area", "Countryside", false)
	
	-- Los Santos
	local ls = cr(118, -815, 2800, -2000, 0, 200, 200, 120)
	setElementParent(ls,radarAreas)
	setElementData(ls, "area", "Los Santos", false)
	
	-- Initiate the radar areas
	for i,radar in pairs(radarAreas) do
		local r,g,b = getRadarAreaColor(radar)
		setRadarAreaColor(radar, r,g,b, 0 )
		setElementDimension(radar, MH_DIMENSION)
	end
end