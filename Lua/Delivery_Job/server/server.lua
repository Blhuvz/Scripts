local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('courier:collectPaycheck')
AddEventHandler('courier:collectPaycheck', function(paycheckAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddMoney('cash', paycheckAmount)
    end
end)