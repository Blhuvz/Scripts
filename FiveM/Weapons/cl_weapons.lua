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