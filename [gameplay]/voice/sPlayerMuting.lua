﻿if isVoiceEnabled() then
	function setPlayerMuted ( player, muted )
		if not checkValidPlayer ( player ) then return false end
		muted = not not muted or nil
		globalMuted[player] = muted
		return setPlayerVoiceBroadcastTo ( player, (not muted) and root or nil )
	end

	function isPlayerMuted ( player )
		if not checkValidPlayer ( player ) then return false end
		return not not globalMuted[player]
	end

	--Returns a list of players of which have muted the specified player
	function getPlayerMutedByList ( player ) 
		if not checkValidPlayer ( player ) then return false end
		return tableToArray(mutedBy[player] or {})
	end

	function updateMuted ( player )
		setPlayerVoiceIgnoreFrom ( player, getPlayerMutedByList ( player ) )
	end


	function addPlayerMutedBy ()
		mutedBy[client] = mutedBy[client] or {}
		mutedBy[client][source] = true
		updateMuted ( client )
	end
	addEventHandler ( "voice_mutePlayerForPlayer", root, addPlayerMutedBy )

	function removePlayerMutedBy ()
		if mutedBy[client] then
			mutedBy[client][source] = nil
			--Refresh the player
			updateMuted ( client )
		end
	end
	addEventHandler ( "voice_unmutePlayerForPlayer", root, removePlayerMutedBy )

	addEventHandler ( "onPlayerQuit", root, 
		function()
			mutedBy[source] = nil
			globalMuted[source] = nil
		end
	)
else
	setPlayerMuted = outputVoiceNotLoaded
	isPlayerMuted = outputVoiceNotLoaded
	getPlayerMutedByList = outputVoiceNotLoaded
end
