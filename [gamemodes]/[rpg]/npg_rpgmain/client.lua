player = getLocalPlayer ( )

addEvent ( "onClientRPGEnter", true )
addEventHandler ( "onClientRPGEnter", root,
	function ( )
		triggerServerEvent ( "onRPGEnter", player )
	end
)



			


