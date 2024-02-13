RegisterCommand('angryPed', function(_, args)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local heading = GetEntityHeading(GetPlayerPed(-1))
    local modelHash = GetHashKey('g_m_m_armboss_01') -- Your desired ped

    if args[1] then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Incorrect use of script. Just use /angryPed'}
        })
        return
    end

    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Cannot spawn a ped while in a vehicle.'}
        })
        return
    end

    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Wait(500)
    end

    local ped = CreatePed(5, modelHash, coords.x, coords.y, coords.z, heading, true, false)

    if not DoesEntityExist(ped) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Ped does not exist.'}
        })
        return
    end

    local weaponHash = GetHashKey('WEAPON_ASSAULTRIFLE_MK2') -- Your desired weapon
    GiveWeaponToPed(ped, weaponHash, 1000, false, true)
    TaskCombatPed(ped, GetPlayerPed(-1), 0, 16)
    SetRelationshipBetweenGroups(5, GetPedRelationshipGroupHash(ped), GetPedRelationshipGroupHash(GetPlayerPed(-1)))

    TriggerEvent('chat:addMessage', {
        color = {52, 128, 235},
        args = {'Spawned a ped with a gun!'}
    })
end, false)