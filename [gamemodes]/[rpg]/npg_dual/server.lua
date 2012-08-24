local myCollision = createColCuboid(1305.3726806641, 2105.2260742188, 10.015625, 85.25, 87, 2)
duelPlayers = {}

addEventHandler ( "onResourceStart", resourceRoot,
    function ( player )
        setElementDimension ( myCollision, 100 )
        loadPlayers ( player )
    end
)

function loadPlayers ( player )
    for i, v in ipairs ( getElementsWithinColShape ( myCollision, "player" )) do
        for p, u in ipairs (getAlivePlayers ( v ) ) do
            giveWeapon ( p, 31, 500 )
            setPedStat ( p, 24, 1000 )
            setElementData ( p, "minigame", "duel", true, true )
        end
        setElementData ( p, "minigame", "noduel", true, true )
    end
end


addEventHandler ( "onColShapeHit", myCollision,
    function ( )
        loadPlayers ( source )
    end
)
    