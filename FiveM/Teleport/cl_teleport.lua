RegisterCommand('teleport', function(_, args)
    local targetLocationBlip = GetFirstBlipInfoId(GetWaypointBlipEnumId())

    if args[1] then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Invalid use of command, Just do /teleport'}
        })

    elseif DoesBlipExist(targetLocationBlip) then
        local targetCoords = GetBlipInfoIdCoord(targetLocationBlip)
        local alt = GetHeightmapTopZForPosition(targetCoords.x, targetCoords.y)

        SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, alt, true, false, false, false)
        FreezeEntityPosition(PlayerPedId(), true)

        local _, ground

        repeat
            Citizen.Wait(100)
            _, ground = GetGroundZFor_3dCoord(targetCoords.x, targetCoords.y, alt, true)
        until ground ~= 0

        SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, ground, true, false, false, false)
        FreezeEntityPosition(PlayerPedId(), false)

        TriggerEvent('chat:addMessage', {
            color = {52, 128, 235},
            args = {'Successfully teleported to waypoint!'}
        })

    else        
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'No destination set on the map!'}
        })
    end
end, false)