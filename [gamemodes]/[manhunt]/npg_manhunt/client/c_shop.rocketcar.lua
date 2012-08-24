function shootrocket(me)
	local occupiedVehicle = getPedOccupiedVehicle(me)
    local rotX,rotY,rotZ = getElementRotation(occupiedVehicle)
    local x, y, z = getElementPosition(occupiedVehicle)
	local matrix = getElementMatrix(occupiedVehicle)
	local offX = 0 * matrix[1][1] + 1 * matrix[2][1] + 0 * matrix[3][1] + 1 * matrix[4][1]
    local offY = 0 * matrix[1][2] + 1 * matrix[2][2] + 0 * matrix[3][2] + 1 * matrix[4][2]
    local offZ = 0 * matrix[1][3] + 1 * matrix[2][3] + 0 * matrix[3][3] + 1 * matrix[4][3]
    local vx = offX - x
    local vy = offY - y
    local vz = offZ - z
    x = 0 * matrix[1][1] + 3 * matrix[2][1] + 0 * matrix[3][1] + 1 * matrix[4][1]
    y = 0 * matrix[1][2] + 3 * matrix[2][2] + 0 * matrix[3][2] + 1 * matrix[4][2]
    z = 0 * matrix[1][3] + 3 * matrix[2][3] + 0 * matrix[3][3] + 1 * matrix[4][3]
    createProjectile(me, 19, x, y, z+2, 200, nil, 0, 0, 360 - rotZ, vx, vy, vz)
	if me == localPlayer then showProgressHUDtwok() end
end

addEvent("mh:shop.rocketcar:shootrocket", true)
addEventHandler("mh:shop.rocketcar:shootrocket", root, shootrocket)