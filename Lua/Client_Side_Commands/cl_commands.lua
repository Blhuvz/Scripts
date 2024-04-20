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

TriggerEvent('chat:addSuggestion', '/fixvehicle', 'Command to fix your vehicle')


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

TriggerEvent('chat:addSuggestion', '/angryped', 'Command to spawn an angry local')


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

        if tonumber(health) < 200 then
            showText("Looks like your injured! Use [/heal] to regain your health/armour", 1000)
            
        elseif health == 0 then
            showText("Looks like your character is incapacitated! Use [/revive] or [/respawn] to revive yourself or respawn at hospital.", 1000)
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

TriggerEvent('chat:addSuggestion', '/revive', 'Command to revive a player', {
    { name="Player ID", help="The ID of the player your wanting to revive" }
})



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

TriggerEvent('chat:addSuggestion', '/heal', 'Command to heal a player', {
    { name="Player ID", help="The player ID of the player you want to heal" }
})



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

TriggerEvent('chat:addSuggestion', '/respawn', 'Command to respawn')


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

TriggerEvent('chat:addSuggestion', '/kill', 'Command to kill a player', {
    { name="Player ID", help="The player ID of the player you want to kill" }
})


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

TriggerEvent('chat:addSuggestion', '/teleport', 'Command to teleport to a waypoint')



-- Weapons Script
RegisterCommand("weapon", function(_, args)
    local weaponName = args[1]

    if not weaponName then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = { "Invalid Input, Example usage: /weapon [weapon]" }
        })
    else
        weaponHandling(weaponName)
    end
end, false)


local validWeapons = {
    {hash = "WEAPON_DAGGER", callName = "dagger" },
    {hash = "WEAPON_BAT", callName = "bat"},
    {hash = "WEAPON_BOTTLE", callName = "bottle"},
    {hash = "WEAPON_CROWBAR", callName = "crowbar"},
    {hash = "WEAPON_UNARMED", callName = "unarmed"},
    {hash = "WEAPON_FLASHLIGHT", callName = "flashlight"},
    {hash = "WEAPON_GOLFCLUB", callName = "golfclub"},
    {hash = "WEAPON_HAMMER", callName = "hammer"},
    {hash = "WEAPON_HATCHET", callName = "hatchet"},
    {hash = "WEAPON_KNUCKLE", callName = "knuckleduster"},
    {hash = "WEAPON_KNIFE", callName = "knife"},
    {hash = "WEAPON_MACHETE", callName = "machete"},
    {hash = "WEAPON_SWITCHBLADE", callName = "switchblade"},
    {hash = "WEAPON_NIGHTSTICK", callName = "nightstick"},
    {hash = "WEAPON_WRENCH", callName = "wrench"},
    {hash = "WEAPON_BATTLEAXE", callName = "battleaxe"},
    {hash = "WEAPON_POOLCUE", callName = "poolcue"},
    {hash = "WEAPON_STONE_HATCHET", callName = "hatchet"},
    {hash = "WEAPON_PISTOL", callName = "pistol"},
    {hash = "WEAPON_PISTOL_MK2", callName = "pistolmk2"},
    {hash = "WEAPON_COMBATPISTOL", callName = "combatpistol"},
    {hash = "WEAPON_APPISTOL", callName = "appistol"},
    {hash = "WEAPON_STUNGUN", callName = "taser"},
    {hash = "WEAPON_PISTOL50", callName = "pistol50"},
    {hash = "WEAPON_SNSPISTOL", callName = "snspistol"},
    {hash = "WEAPON_SNSPISTOL_MK2", callName = "snspistolmk2"},
    {hash = "WEAPON_HEAVYPISTOL", callName = "heavypistol"},
    {hash = "WEAPON_VINTAGEPISTOL", callName = "vintagepistol"},
    {hash = "WEAPON_FLAREGUN", callName = "flaregun"},
    {hash = "WEAPON_MARKSMANPISTOL", callName = "marksmanpistol"},
    {hash = "WEAPON_REVOLVER", callName = "revolver"},
    {hash = "WEAPON_REVOLVER_MK2", callName = "revolvermk2"},
    {hash = "WEAPON_DOUBLEACTION", callName = "doubleaction"},
    {hash = "WEAPON_RAYPISTOL", callName = "raypistol"},
    {hash = "WEAPON_CERAMICPISTOL", callName = "ceramicpistol"},
    {hash = "WEAPON_NAVYREVOLVER", callName = "navyrevolver"},
    {hash = "WEAPON_MICROSMG", callName = "microsmg"},
    {hash = "WEAPON_SMG", callName = "smg"},
    {hash = "WEAPON_SMG_MK2", callName = "smgmk2"},
    {hash = "WEAPON_ASSAULTSMG", callName = "assaultsmg"},
    {hash = "WEAPON_COMBATPDW", callName = "combatpdw"},
    {hash = "WEAPON_MACHINEPISTOL", callName = "machinepistol"},
    {hash = "WEAPON_MINISMG", callName = "minismg"},
    {hash = "WEAPON_RAYCARBINE", callName = "raycarbine"},
    {hash = "WEAPON_PUMPSHOTGUN", callName = "pumpshotgun"},
    {hash = "WEAPON_PUMPSHOTGUN_MK2", callName = "pumpshotgunmk2"},
    {hash = "WEAPON_SAWNOFFSHOTGUN", callName = "sawnoffshotgun"},
    {hash = "WEAPON_ASSAULTSHOTGUN", callName = "assaultshotgun"},
    {hash = "WEAPON_BULLPUPSHOTGUN", callName = "bullpupshotgun"},
    {hash = "WEAPON_MUSKET", callName = "musket"},
    {hash = "WEAPON_HEAVYSHOTGUN", callName = "heavyshotgun"},
    {hash = "WEAPON_DBSHOTGUN", callName = "dbshotgun"},
    {hash = "WEAPON_AUTOSHOTGUN", callName = "autoshotgun"},
    {hash = "WEAPON_ASSAULTRIFLE", callName = "assaultrifle"},
    {hash = "WEAPON_ASSAULTRIFLE_MK2", callName = "assaultriflemk2"},
    {hash = "WEAPON_CARBINERIFLE", callName = "carbinerifle"},
    {hash = "WEAPON_CARBINERIFLE_MK2", callName = "carbineriflemk2"},
    {hash = "WEAPON_ADVANCEDRIFLE", callName = "advancedrifle"},
    {hash = "WEAPON_SPECIALCARBINE", callName = "specialcarbine"},
    {hash = "WEAPON_SPECIALCARBINE_MK2", callName = "specialcarbinemk2"},
    {hash = "WEAPON_BULLPUPRIFLE", callName = "bullpuprifle"},
    {hash = "WEAPON_BULLPUPRIFLE_MK2", callName = "bullpupriflemk2"},
    {hash = "WEAPON_COMPACTRIFLE", callName = "compactrifle"},
    {hash = "WEAPON_MG", callName = "mg"},
    {hash = "WEAPON_COMBATMG", callName = "combatmg"},
    {hash = "WEAPON_COMBATMG_MK2", callName = "combatmgmk2"},
    {hash = "WEAPON_GUSENBERG", callName = "gusenberg"},
    {hash = "WEAPON_SNIPERRIFLE", callName = "sniperrifle"},
    {hash = "WEAPON_HEAVYSNIPER", callName = "heavysniper"},
    {hash = "WEAPON_HEAVYSNIPER_MK2", callName = "heavysnipermk2"},
    {hash = "WEAPON_MARKSMANRIFLE", callName = "marksmanrifle"},
    {hash = "WEAPON_MARKSMANRIFLE_MK2", callName = "marksmanriflemk2"},
    {hash = "WEAPON_RPG", callName = "rpg"},
    {hash = "WEAPON_GRENADELAUNCHER", callName = "grenadelauncher"},
    {hash = "WEAPON_GRENADELAUNCHER_SMOKE", callName = "grenadelaunchersmoke"},
    {hash = "WEAPON_MINIGUN", callName = "minigun"},
    {hash = "WEAPON_FIREWORK", callName = "firework"},
    {hash = "WEAPON_RAILGUN", callName = "railgun"},
    {hash = "WEAPON_HOMINGLAUNCHER", callName = "hominglauncher"},
    {hash = "WEAPON_COMPACTLAUNCHER", callName = "compactlauncher"},
    {hash = "WEAPON_RAYMINIGUN", callName = "rayminigun"},
    {hash = "WEAPON_GRENADE", callName = "grenade"},
    {hash = "WEAPON_BZGAS", callName = "bzgas"},
    {hash = "WEAPON_SMOKEGRENADE", callName = "smokegrenade"},
    {hash = "WEAPON_FLARE", callName = "flare"},
    {hash = "WEAPON_MOLOTOV", callName = "molotov"},
    {hash = "WEAPON_STICKYBOMB", callName = "stickybomb"},
    {hash = "WEAPON_PROXMINE", callName = "proxmine"},
    {hash = "WEAPON_SNOWBALL", callName = "snowball"},
    {hash = "WEAPON_PIPEBOMB", callName = "pipebomb"},
    {hash = "WEAPON_BALL", callName = "ball"},
    {hash = "WEAPON_PETROLCAN", callName = "petrolcan"},
    {hash = "WEAPON_FIREEXTINGUISHER", callName = "fireextinguisher"},
    {hash = "WEAPON_PARACHUTE", callName = "parachute"},
    {hash = "WEAPON_HAZARDCAN", callName = "hazardcan"}
}


function weaponHandling(weaponName)
    local myPed = GetPlayerPed(-1)

    for _, validWeapon in ipairs(validWeapons) do
        if string.lower(weaponName) == string.lower(validWeapon.callName) then
            local weaponHash = GetHashKey(validWeapon.hash)

            if HasPedGotWeapon(myPed, weaponHash, false) then
                TriggerEvent('chat:addMessage', {
                    color = {255, 0, 0},
                    args = { "You already have a " .. weaponName }
                })
                return
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
                return
            end
        end
    end

    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        args = { weaponName .. " is not a valid weapon" }
    })
end

TriggerEvent('chat:addSuggestion', '/weapon', 'Command to spawn a weapon', {
    { name="weapon name", help="The name of the weapon your wanting to spawn" }
})



-- Weather Scripts 
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

function contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

TriggerEvent('chat:addSuggestion', '/setweather', 'Command to set the weather')


-- Car Spawner
RegisterCommand('vehicle', function(_, args)
    local vehicleName = args[1] or 'tornado'

    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = { vehicleName .. ' does not exist! ' }
        })
        return
    end

    RequestModel(vehicleName)

    CreateThread(function()
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

TriggerEvent('chat:addSuggestion', '/vehicle', 'Command to spawn a vehicle', {
    { name="vehicle", help="The name of the vehicle you are wanting to spawn" }
})