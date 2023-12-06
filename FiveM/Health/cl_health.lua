RegisterCommand('revive', function(source, args)

    if args[1]:lower() == 'me' then
        playerId = source
    else
        playerId = tonumber(args[1])
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
    if args[1]:lower() == 'me' then
        playerId = source
    else
        playerId = tonumber(args[1])
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