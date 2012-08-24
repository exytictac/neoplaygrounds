addEventHandler ( "onResourceStart", resourceRoot,
	function ( )
		newFile = fileCreate("npg_logs/test.txt")
	end
)

addEventHandler ( "onPlayerJoin", resourceRoot,
	function ( )
		fileWrite(newFile, "This is a test file!")
	end
)
		--fileClose(newFile) 