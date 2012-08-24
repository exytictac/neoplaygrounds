addEvent ( "addFreeroamColumn", true )
addEventHandler ( "addFreeroamColumn", root, 
	function( )
		exports.scoreboard:addScoreboardColumn ( "Minigame", source, 1, 0.08 )
		setElementData ( source, "Minigame", "None" )
	end
)

addEvent ( "onPlayerRaceEnter", true )

addEventHandler ( "onPlayerRaceEnter", root, 
	function( )
		setTimer ( redirectPlayer, 1000, 1, source, "178.33.90.181", 22006 )
	end
)


function playerPosition(playerSource)
	x, y, z = getElementPosition(playerSource)
	int = getElementInterior( playerSource )
	dim = getElementDimension( playerSource )
	outputChatBox("X,Y,Z = ".. tostring(x) ..",".. tostring(y) ..",".. tostring(z) .."", playerSource) 
	outputChatBox("Interior: ".. tostring(int) .. "  Dimension: ".. tostring(dim) .."", playerSource)
end

addCommandHandler("getpos", playerPosition)


addEventHandler("onResourceStart", getResourceRootElement( getThisResource() ), 
function()
	setGameType("NPG 0.1")
end
)



local chatCompetition = false
local wordsTable ={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
local word = ""
local win

function genWord()
	local w = ''
	local t = math.random(2,4)
	local v = math.random(3,5)
	for i = 1, 6 do
		if i==t or i==v then
			w = w..math.random(0,9)
		else
			local a = math.random(2)==2 and string.upper or string.lower
			local b = wordsTable[ math.random(#wordsTable) ]
			w = w..a(b)
		end
	end
	return w
end
function setRandomWord()
	win = math.random ( 1, 10000 )
    word = genWord()
    outputChatBox("Write ".. word .." to get "..win.." dollars!",root,255,255,0)
    chatCompetition = true
end
setTimer(setRandomWord,600000,0)

 
addEventHandler('onPlayerChat',root,
    function(message, messageType)
        if (messageType == 0 and message == word and chatCompetition) then
            chatCompetition = false
            word = ""
            givePlayerMoney(source, win)
            outputChatBox(getPlayerName(source) .." got " ..win.." dollars!",root,0,255,0,false)
        end
    end
)
