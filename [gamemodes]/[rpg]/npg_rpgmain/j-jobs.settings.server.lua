--[[
	RPG Jobs v2.0.1 [settings.server]
	
	Made By: JR10
	
	Copyright (c) 2011
]]

--Resource Settings

--ONLY EDIT THIS IF YOU KNOW WHAT YOU ARE DOING

settingTraderTeamColor	=	{ 255 , 255 , 0 } -- The color of Trader team in RGB format
settingMechanicTeamColor = { 255 , 255 , 0 } -- Mechanic team color RGB format
settingHitmanTeamColor = { 150 , 150 , 150 } -- Hitman team color in RGB format
settingPoliceTeamColor = { 0 , 150 , 255 } -- Police team color in RGB format
settingSeekerTeamColor = { 255 , 153 , 0 } -- Seeker team color in RGB format
settingOffdutyTeamColor = { 183 , 113 , 113 } -- Offduty team color in RGB format
settingTaxiTeamColor = { 255, 255, 0 } -- Taxi team color in RGB format
settingPizzaTeamColor = { 255, 255, 0 } -- Pizza team color in RGB format
settingLimoTeamColor = { 255, 255, 0 } -- Limo team color in RGB format
settingMedicTeamColor =  { 255, 0, 0 }
settingMilitaryTeamColor = { 255, 0, 20 }
settingBusTeamColor = { 255, 255, 0 } -- Bus team color in RGB format
settingPoliceHQBlip = 30 -- Police Headquarter (LSPD) blip icon
settingTraderHQBlip = 42 -- Trader HQ blip icon
settingMedicHQBlip = 22 -- Medic HQ blip icon
settingPizzaHQBlip = 56 -- Pizza HQ blip icon
settingMechanicHQBlip = 27 -- Mechanic HQ blip icon
settingHitmanHQBlip = 23 -- Hitman HQ blip icon
settingBusHQBlip = 56 -- Bus HQ blwip icon
settingSeekerHQBlip = 37 -- Seeker HQ blip icon
settingMilitaryHQBlip = 6 -- Military HQ blip icon
settingTaxiHQBlip = 56 -- Taxi HQ blip icon
settingLimoHQBlip = 56 -- Limo HQ blip icon
settingShipBlip = 9 -- The blip icon of the ship
settingSellMerchandiseMarkerBlip = 19 -- Sell merchandise marker blip icon
settingFriendlyFireForTeams = false -- Friendly fire for teams
settingTakePlayerWeaponsOnArrest = true -- Take all player weapons when he is arrested
settingShowCursor = "M" -- The key to use with bindKey to show and hide the cursor
settingPrisonLocation = { 264.5810546875 , 77.6474609375 , 1001.0390625 , 6 , 2 , 270 } -- The prison location, posX , posY , posZ , interior , dimension , rotation
settingDutyKey = "F1" -- The key to open/close the Duty GUI
settingPoliceCharSkinID = 265 -- Police Character Skin ID
settingPoliceCharName = "Officer Tenpenny" -- Police Character Name
settingMedicCharSkinID = 274
settingMedicCharName = "Peter"
settingTraderCharSkinID = 303 -- Trader Character Skin ID
settingTraderCharName = "Merchant Victor"					-- Trader Character Name
settingBusCharName = "Vincent" -- Bus Character Name
settingBusCharSkinID = 61 -- Bus Characted Skin ID
settingMechanicCharSkinID = 50 -- Mechanic Character Skin ID
settingMechanicCharName = "Mechanic Rick" -- Mechanic Character Name
settingHitmanCharSkinID = 299 -- Hitman Character Skin ID
settingHitmanCharName = "Hitman Claude" -- Hitman Character Name
settingSeekerCharSkinID = 249 -- Seeker Character Skin ID
settingSeekerCharName = "Seeker Tommy" -- Seeker Character Name
settingTaxiCharSkinID = 253 -- Taxi Character Skin ID
settingTaxiCharName = "Daniel" -- Taxi Character Name
settingPizzaCharName = "Tom"
settingPizzaCharSkinID = 155
settingMilitaryCharSkinID = 287 
settingMilitaryCharName = "Ryan"
settingLimoCharSkinID = 255
settingLimoCharName = "Rico"
settingBriefcasePrize = 15 -- Briefcase prize works as following, the distance between the new assignment marker and the briefcase is multiplied by this setting value

-- Briefcase Locations Table
bcTable = {
	{ 880.1103515625 , -1101.802734375 , 24.296875 } ,
	{ 585.0068359375 , -1871.5966796875 , 4.3772277832031 } ,
	{ 153.5947265625 , -1922.2119140625 , 3.7696437835693 } ,
	{ 52.884765625 , -1532.857421875 , 11.956685066223 } ,
	{ -1835.3857421875 , -2647.1875 , 54.877414703369 } ,
	{ -2076.16796875 , -2535.630859375 , 30.625 } ,
	{ -1644.33984375 , -253.3173828125 , 14.1484375 } ,
	{ -953.2216796875 , -321.115234375 , 36.914710998535 } ,
	{ 66.8408203125 , -233.8349609375 , 1.5723714828491 } ,
	{ -190.5947265625 , 108.6708984375 , 3.0951910018921 } ,
	{ -180.6298828125 , 286.0185546875 , 27.554412841797 } ,
	{ -187.541015625 , 287.685546875 , 27.275123596191 } ,
	{ -173.58203125 , 336.9873046875 , 20.8688621521 } ,
	{ -492.765625 , 1214.7216796875 , 37.307838439941 } ,
	{ -554.1123046875 , 1201.51953125 , 34.822849273682 } ,
	{ -808.158203125 , 1367.2060546875 , 23.434051513672 } ,
	{ 1865.1142578125 , -216.01953125 , 38.430313110352 }
}