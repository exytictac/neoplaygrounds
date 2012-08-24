local w, h = guiGetScreenSize( );
local enable = false;

addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource() ),
	function( )
		bindKey( "x", "up", enableBonusScreen );
	end
)

function renderEffect( )
	dxSetRenderTarget( );
	dxUpdateScreenSource( screenSrc );
	dxDrawImage( 0, 0, w, h, screenShader );
	setTime(12,0)
end

function enableBonusScreen( )
	if getElementData(localPlayer, "gamemode") ~= "manhunt" then return end
	enable = not enable;
	if enable then
		outputChatBox("15 second bonus")
		screenShader = dxCreateShader( "bonus.fx" );
		screenSrc = dxCreateScreenSource( w, h );
		if screenShader and screenSrc then
			dxSetShaderValue( screenShader, "ManhuntBonusTexture", screenSrc );
			addEventHandler( "onClientHUDRender", root, renderEffect );
		end
	else
		if screenShader and screenSrc then
			destroyElement( screenShader );
			destroyElement( screenSrc );
			screenShader, screenSrc = nil, nil;
			removeEventHandler( "onClientHUDRender", root, renderEffect );
		end
	end
end