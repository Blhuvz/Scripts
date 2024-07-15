QBCore = exports['qb-core']:GetCoreObject()

local deliveryVehicle = nil
local deliveryNpc = nil
local deliveryStartBlip = nil
local currentDelivery = nil
local deliveryLocations = {}
local deliveryBlip = nil

function createStartJobBlip()
    deliveryStartBlip = AddBlipForCoord(Config.StartingLocation.x, Config.StartingLocation.y, Config.StartingLocation.z)
    SetBlipSprite(deliveryStartBlip, 85)
    SetBlipDisplay(deliveryStartBlip, 4)
    SetBlipScale(deliveryStartBlip, 0.9)
    SetBlipColour(deliveryStartBlip, 2)
    SetBlipAsShortRange(deliveryStartBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Delivery Job")
    EndTextCommandSetBlipName(deliveryStartBlip)
end


function initializeDeliveryLocations()
    for _, location in ipairs(Config.DeliveryLocations) do
        table.insert(deliveryLocations, location)
    end
end


function getRandomDelivery()
    if #deliveryLocations == 0 then
        initializeDeliveryLocations()
    end

    local deliveryIndex = math.random(1, #deliveryLocations)
    return table.remove(deliveryLocations, deliveryIndex)
end


RegisterNetEvent('random:client:collectVan')
AddEventHandler('random:client:collectVan', function()
    if DoesEntityExist(deliveryVehicle) then
        QBCore.Functions.Notify("You already have a delivery van.", "error")
        return
    end

    local vehicleModel = GetHashKey("boxville2")

    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Wait(1)
    end

    local playerPed = PlayerPedId()
    deliveryVehicle = CreateVehicle(vehicleModel, Config.DeliveryParking.x, Config.DeliveryParking.y, Config.DeliveryParking.z, Config.DeliveryParking.heading, true, false)

    wait(100)

    SetVehicleFuelLevel(deliveryVehicle, 100)
    local id = NetworkGetNetworkIdFromEntity(deliveryVehicle)

    SetNetworkIdCanMigrate(id, true)
    TaskWarpPedIntoVehicle(playerPed, deliveryVehicle, -1)
    SetEntityAsMissionEntity(deliveryVehicle, true, true)

    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(deliveryVehicle))
    currentDelivery = getRandomDelivery()

    deliveryNpc = CreatePed(4, GetHashKey("a_m_m_business_01"), currentDelivery.x, currentDelivery.y, currentDelivery.z, heading, true, true)
    SetEntityAsMissionEntity(deliveryNpc, true, true)
    FreezeEntityPosition(deliveryNpc, true)
    SetEntityInvincible(deliveryNpc, true)
    SetBlockingOfNonTemporaryEvents(deliveryNpc, true)

    deliveryBlip = AddBlipForEntity(deliveryNpc)
    SetBlipSprite(deliveryBlip, 1)
    SetBlipDisplay(deliveryBlip, 4)
    SetBlipColour(deliveryBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Delivery Location")
    EndTextCommandSetBlipName(deliveryBlip)

    SetNewWaypoint(currentDelivery.x, currentDelivery.y)
    SetBlipRoute(GetWaypointBlipEnumId())

    SetNewWaypoint(currentDelivery.x, currentDelivery.y)
    Wait(0)
    SetBlipRoute(GetWaypointBlipEnumId())
    QBCore.Functions.Notify("Delivery van spawned. GPS set for first delivery.", "success")
end)


CreateThread(function()
    while true do
        Wait(10)
        if deliveryNpc then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local npcCoords = GetEntityCoords(deliveryNpc)
            if #(playerCoords - npcCoords) < 1.0 then
                QBCore.Functions.DrawText3D(npcCoords.x, npcCoords.y, npcCoords.z, "[E] Deliver Package")
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('deliveryjob:completeDelivery')
                end
            end
        end
    end
end)


RegisterNetEvent('deliveryjob:completeDelivery')
AddEventHandler('deliveryjob:completeDelivery', function()
    QBCore.Functions.Notify("Delivery completed!", "success")
    currentDelivery = getRandomDelivery()

    local currentPos = GetEntityCoords(PlayerPedId())
    local distance = #(currentPos - vector3(currentDelivery.x, currentDelivery.y, currentDelivery.z))
    local payment = Config.BaseReward + Config.DistanceMultiplier * distance
    TriggerServerEvent('deliveryjob:collectPaycheck', payment)

    if deliveryNpc then
        RemoveBlip(deliveryBlip)
        DeleteEntity(deliveryNpc)
        deliveryNpc = nil
    end

    deliveryNpc = CreatePed(4, GetHashKey("a_m_m_business_01"), currentDelivery.x, currentDelivery.y, currentDelivery.z, currentDelivery.heading, true, true)
    SetEntityAsMissionEntity(deliveryNpc, true, true)
    FreezeEntityPosition(deliveryNpc, true)
    SetEntityInvincible(deliveryNpc, true)
    SetBlockingOfNonTemporaryEvents(deliveryNpc)

    deliveryBlip = AddBlipForEntity(deliveryNpc)
    SetBlipSprite(deliveryBlip, 1)
    SetBlipDisplay(deliveryBlip, 4)
    SetBlipColour(deliveryBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Delivery NPC")
    EndTextCommandSetBlipName(deliveryBlip)

    SetNewWaypoint(currentDelivery.x, currentDelivery.y)
    SetBlipRoute(GetWaypointBlipEnumId())
end)


CreateThread(function()
    while true do
        Wait(10)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle == deliveryVehicle then
                while true do
                    Wait(100)
                    if IsControlJustReleased(0, 75) then
                        ExecuteCommand('e box')
                    end

                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local npcCoords = GetEntityCoords(deliveryNpc)
                    if #(playerCoords - npcCoords) < 1.5 then
                        ExecuteCommand('e c')
                    end
                end
            end
        end
    end
end)


CreateThread(function()
    createStartJobBlip()
    initializeDeliveryLocations()
end)