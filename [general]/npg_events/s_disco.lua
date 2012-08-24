--[[
function changeColorSky()
    red = red or math.random( 0, 255 )
    green = green or math.random( 0, 255 )
    blue = blue or math.random( 0, 255 )
    alpha = 255
    setSkyGradient( math.random(0,255), math.random(0,255), math.random(0,255) )
end
  
setTimer ( changeColorSky, 100, 0 )


function changeColorWater()
    red = red or math.random( 0, 255 )
    green = green or math.random( 0, 255 )
    blue = blue or math.random( 0, 255 )
    alpha = 255
    setWaterColor( math.random(0,255), math.random(0,255), math.random(0,255) )
end
  
setTimer ( changeColorWater, 100, 0 )]]--



