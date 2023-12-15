RegisterCommand('fixVehicle', function(_, args)
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