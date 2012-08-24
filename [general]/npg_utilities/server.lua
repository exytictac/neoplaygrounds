function showRoadmap(thePlayer)
		outputChatBox("Current progress may take some time to load...", thePlayer, 255, 194, 15)
		callRemote("http://noddy.mtasa.pl/index.php", displayRoadmap, thePlayer)
	end
addCommandHandler("roadmap", showRoadmap)

function displayRoadmap(err, no,msg)
	if (err~="ERROR") then
		outputChatBox("~~~~~~~~~~~~~~~~~~ Progress ~~~~~~~~~~~~~~~~~~", no, 255, 194, 15)
		outputChatBox(msg, no, 255, 194, 15)
	else
		outputChatBox('Did you expect anything to happen, nubcaek?')
	end
end

-- result is called when the function returns
function result(p, sum)
    if sum ~= "ERROR" then
        outputChatBox('Here, '..getPlayerName(p)..': '..sum,p)
    else
		outputChatBox('Did you expect anything to happen, nubcaek?')
	end
end
function addNumbers(p,_,number1, number2)
    callRemote ( "http://noddy.mtasa.pl/index.php", result, p, tonumber(number1)or 0, tonumber(number2)or 0 )
end 
addCommandHandler('add', addNumbers)