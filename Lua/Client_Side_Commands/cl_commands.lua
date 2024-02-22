-- Fully repair vehicle
RegisterCommand('fixvehicle', function(_, args)
    if args[1] then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Incorrect use of script. Just use /fixVehicle'}
        })
    else
        local playerPed = GetPlayerPed(-1)

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                SetVehicleDirtLevel(vehicle, 0.0)
                SetVehicleOnGroundProperly(vehicle)

                TriggerEvent('chat:addMessage', {
                    color = {52, 128, 235},
                    args = {'Vehicle repaired and cleaned!'}
                })
            end
        else
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                args = {'You are not in a vehicle!'}
            })
        end
    end
end, false)



-- Angry ped
RegisterCommand('angryped', function(_, args)
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

    local weaponHash = GetHashKey('WEAPON_PISTOL50') -- Your desired weapon
    GiveWeaponToPed(ped, weaponHash, 1000, false, true)
    TaskCombatPed(ped, GetPlayerPed(-1), 0, 16)
    SetRelationshipBetweenGroups(5, GetPedRelationshipGroupHash(ped), GetPedRelationshipGroupHash(GetPlayerPed(-1)))

    TriggerEvent('chat:addMessage', {
        color = {52, 128, 235},
        args = {'Spawned a ped with a gun!'}
    })
end, false)



-- Health Scripts
function showText(message, duration)
    BeginTextCommandPrint("STRING")
    AddTextComponentString(message)
    EndTextCommandPrint(duration, true)
end

CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped)
        local isDead = IsEntityDead(ped)

        if tonumber(health) < 200 then
            showText("Looks like your injured! Use [/heal] to regain your health/armour", 10000)
            
        elseif isDead then
            showText("Looks like your character is incapacitated! Use [/revive] or [/respawn] to revive yourself or respawn at hospital.", 10000)
        end

        Wait(1000)
    end
end)

RegisterCommand('revive', function(source, args)
    if args[1] and args[1] ~= 'me' then
        playerId = tonumber(args[1])
    else
        playerId = source
    end
    
    local playerPed = GetPlayerPed(-1)

    if not playerId then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Invalid use of command, try /revive [id]'}
        })
        return
    end

    if DoesEntityExist(playerPed) and IsEntityDead(playerPed) then
        TriggerEvent('chat:addMessage', {
            color = {52, 128, 235},
            args = {'Reviving player...'}
        })

        Wait(500)

        TriggerEvent('chat:addMessage', {
            color = {11, 8, 201},
            args = {'Player Successfully revived!'}
        })

        NetworkResurrectLocalPlayer(GetEntityCoords(playerPed, true), true, true, false)

        return
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Player is in an incorrect state'}
        })
    end
end, false)



RegisterCommand('heal', function(source, args)
    if args[1] and args[1] ~= 'me' then
        playerId = tonumber(args[1])
    else
        playerId = source
    end

    local playerPed = GetPlayerPed(-1)

    if not playerId then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Invalid use of command, try /heal [id]'}
        })
        return
    end

    if DoesEntityExist(playerPed) and not IsPlayerDead(playerPed) then
        local maxHealth = GetEntityMaxHealth(playerPed)
        local currentHealth = GetEntityHealth(playerPed)

        if currentHealth < maxHealth then
            SetEntityHealth(playerPed, maxHealth)

            TriggerEvent('chat:addMessage', {
                color = {17, 186, 65},
                args = {'Healing player...'}
            })

            Wait(500)

            TriggerEvent('chat:addMessage', {
                color = {11, 8, 201},
                args = {'Player Successfully Healed!'}
            })
        else
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                args = {'Player is already at full health'}
            })
        end

        return
    else
        TriggerEvent('chat:addMessage', {
            args = {'Player is in an incorrect state'}
        })
    end
end, false)

-- Respawn
local hospitals = {
    {coords = vector3(298.66693, -584.3158, 43.260841), heading = 68.6855, name = "Pillbox Hospital"},
    {coords = vector3(330.98733, -1395.251, 32.50925), heading = 44.2197, name = "Strawberry Hospital"},
    {coords = vector3(1839.675, 3672.7021, 34.276706), heading = 207.95399, name = "Sandy Hospital"},
    {coords = vector3(-247.6553, 6331.0273, 32.426181), heading = 224.86921, name = "Paleto Hospital"}
}

RegisterCommand("respawn", function()
    local isDead = IsEntityDead(GetPlayerPed(-1))

    if isDead then
        local hospital = hospitals[math.random(#hospitals)]
        local hospitalPos = hospital.coords
        local heading = hospital.heading
        local hospitalName = hospital.name

        NetworkResurrectLocalPlayer(hospitalPos.x, hospitalPos.y, hospitalPos.z, true, true, false)
        SetEntityHeading(GetPlayerPed(-1), heading)

        TriggerEvent('chat:addMessage', {
            color = {255, 255, 255},
            args = {'You have respawned, Welcome to ' .. hospitalName}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'You are not dead, cannot respawn.'}
        })
    end
end, false)

-- Kill Ped 
RegisterCommand('kill', function(source, args)
    if args[1] and args[1] ~= 'me' then
        playerId = tonumber(args[1])
    else
        playerId = source
    end
    
    local playerPed = GetPlayerPed(-1)

    if not playerPed then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Invalid use of command just do [/kill me].'}
        })
        return
    end

    if not IsEntityDead(playerPed) then
        SetEntityHealth(playerPed, 0)

        TriggerEvent('chat:addMessage', {
            color = {52, 128, 235},
            args = {'Killing player...'}
        })

        Wait(500)

        TriggerEvent('chat:addMessage', {
            color = {11, 8, 201},
            args = {'Player Successfully killed!'}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Player is already dead.'}
        })
    end
end, false)




-- Teleport Command
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
            Wait(100)
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
            args = {'No waypoint set on the map!'}
        })
    end
end, false)



-- Weapons Script
RegisterCommand("weapon", function(_, args)
    local weaponName = args[1]
    local myPed = GetPlayerPed(-1)

    if not weaponName then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = { "Invalid Input, Example usaage: /gun [weapon]" }
        })
        return
    end

    if IsWeaponValid(weaponName) then
        local weaponHash = GetHashKey(weaponName)

        if HasPedGotWeapon(myPed, weaponHash, false) then
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                args = { "You already have a " .. weaponName }
            })
        else
            RequestWeaponAsset(weaponHash)

            while not HasWeaponAssetLoaded(weaponHash) do
                Wait(500)
            end

            GiveWeaponToPed(myPed, weaponHash, 1000, false, true) 

            TriggerEvent('chat:addMessage', {
                color = {52, 128, 235},
                args = { "You received a " .. weaponName }
            })
        end
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = { weaponName .. " is not a valid weapon" }
        })
    end
end, false)

function IsWeaponValid(weaponName)
    local validWeapons = {
        "WEAPON_DAGGER",
        "WEAPON_BAT",
        "WEAPON_BOTTLE",
        "WEAPON_CROWBAR",
        "WEAPON_UNARMED",
        "WEAPON_FLASHLIGHT",
        "WEAPON_GOLFCLUB",
        "WEAPON_HAMMER",
        "WEAPON_HATCHET",
        "WEAPON_KNUCKLE",
        "WEAPON_KNIFE",
        "WEAPON_MACHETE",
        "WEAPON_SWITCHBLADE",
        "WEAPON_NIGHTSTICK",
        "WEAPON_WRENCH",
        "WEAPON_BATTLEAXE",
        "WEAPON_POOLCUE",
        "WEAPON_STONE_HATCHET",
        "WEAPON_PISTOL",
        "WEAPON_PISTOL_MK2",
        "WEAPON_COMBATPISTOL",
        "WEAPON_APPISTOL",
        "WEAPON_STUNGUN",
        "WEAPON_PISTOL50",
        "WEAPON_SNSPISTOL",
        "WEAPON_SNSPISTOL_MK2",
        "WEAPON_HEAVYPISTOL",
        "WEAPON_VINTAGEPISTOL",
        "WEAPON_FLAREGUN",
        "WEAPON_MARKSMANPISTOL",
        "WEAPON_REVOLVER",
        "WEAPON_REVOLVER_MK2",
        "WEAPON_DOUBLEACTION",
        "WEAPON_RAYPISTOL",
        "WEAPON_CERAMICPISTOL",
        "WEAPON_NAVYREVOLVER",
        "WEAPON_MICROSMG",
        "WEAPON_SMG",
        "WEAPON_SMG_MK2",
        "WEAPON_ASSAULTSMG",
        "WEAPON_COMBATPDW",
        "WEAPON_MACHINEPISTOL",
        "WEAPON_MINISMG",
        "WEAPON_RAYCARBINE",
        "WEAPON_PUMPSHOTGUN",
        "WEAPON_PUMPSHOTGUN_MK2",
        "WEAPON_SAWNOFFSHOTGUN",
        "WEAPON_ASSAULTSHOTGUN",
        "WEAPON_BULLPUPSHOTGUN",
        "WEAPON_MUSKET",
        "WEAPON_HEAVYSHOTGUN",
        "WEAPON_DBSHOTGUN",
        "WEAPON_AUTOSHOTGUN",
        "WEAPON_ASSAULTRIFLE",
        "WEAPON_ASSAULTRIFLE_MK2",
        "WEAPON_CARBINERIFLE",
        "WEAPON_CARBINERIFLE_MK2",
        "WEAPON_ADVANCEDRIFLE",
        "WEAPON_SPECIALCARBINE",
        "WEAPON_SPECIALCARBINE_MK2",
        "WEAPON_BULLPUPRIFLE",
        "WEAPON_BULLPUPRIFLE_MK2",
        "WEAPON_COMPACTRIFLE",
        "WEAPON_MG",
        "WEAPON_COMBATMG",
        "WEAPON_COMBATMG_MK2",
        "WEAPON_GUSENBERG",
        "WEAPON_SNIPERRIFLE",
        "WEAPON_HEAVYSNIPER",
        "WEAPON_HEAVYSNIPER_MK2",
        "WEAPON_MARKSMANRIFLE",
        "WEAPON_MARKSMANRIFLE_MK2",
        "WEAPON_RPG",
        "WEAPON_GRENADELAUNCHER",
        "WEAPON_GRENADELAUNCHER_SMOKE",
        "WEAPON_MINIGUN",
        "WEAPON_FIREWORK",
        "WEAPON_RAILGUN",
        "WEAPON_HOMINGLAUNCHER",
        "WEAPON_COMPACTLAUNCHER",
        "WEAPON_RAYMINIGUN",
        "WEAPON_GRENADE",
        "WEAPON_BZGAS",
        "WEAPON_SMOKEGRENADE",
        "WEAPON_FLARE",
        "WEAPON_MOLOTOV",
        "WEAPON_STICKYBOMB",
        "WEAPON_PROXMINE",
        "WEAPON_SNOWBALL",
        "WEAPON_PIPEBOMB",
        "WEAPON_BALL",
        "WEAPON_PETROLCAN",
        "WEAPON_FIREEXTINGUISHER",
        "WEAPON_PARACHUTE",
        "WEAPON_HAZARDCAN"
    }

    for _, validWeapon in ipairs(validWeapons) do
        if weaponName == validWeapon then
            return true
        end
    end

    return false
end



-- Weather Scripts 
function contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

RegisterCommand("setweather", function(_, args)
    local weatherType = args[1] or "clear"

    local correctWeatherTypes = {
        "clear",
        "extra sunny",
        "clouds",
        "overcast",
        "rain",
        "thunder",
        "smog",
        "foggy",
        "light rain",
        "clearing",
        "neutral",
        "hazy",
        "dark",
        "foggy",
        "light rain",
        "xmas",
        "snowlight",
        "blizzard"
    }

    if not contains(correctWeatherTypes, weatherType) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"Invalid weather type. "}
        })
        return
    else
        SetWeatherTypeNowPersist(weatherType)

        TriggerEvent('chat:addMessage', {
            color = {52, 128, 235},
            args = {"The weather is now " .. weatherType}
        })
    end
end, false)



-- Car Spawner
RegisterCommand('vehicle', function(source, args)
    local vehicleName = args[1] or 'adder'

    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = { vehicleName .. ' does not exist! ' }
        })
        return
    end

    RequestModel(vehicleName)

    Citizen.CreateThread(function()
        local timeout = 10
        local start = GetGameTimer()

        while not HasModelLoaded(vehicleName) do
            if GetGameTimer() - start > timeout * 1000 then
                TriggerEvent('chat:addMessage', {
                    color = {255, 0, 0},
                    args = { 'Failed to load the vehicle model ' .. vehicleName .. ' in time.' }
                })
                return
            end
            Wait(500)
        end

        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, heading, true, false)

        if DoesEntityExist(vehicle) then
            SetPedIntoVehicle(playerPed, vehicle, -1)
            SetEntityAsNoLongerNeeded(vehicle)
            SetModelAsNoLongerNeeded(vehicleName)

            TriggerEvent('chat:addMessage', {
                color = {52, 128, 235},
                args = { 'Successfully spawned in a ' .. vehicleName .. '!' }
            })
        else
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                args = { 'Failed to create the vehicle, Please try again! ' }
            })
        end
    end)
end, false)