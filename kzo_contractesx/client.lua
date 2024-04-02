RegisterNUICallback('escape', function()
    SetNuiFocus(false, false)
end)
RegisterNUICallback('writecontract', function(data)
    TriggerServerEvent('kzo_contract:writecontact', data.player, data.vehicle)
end)
Citizen.CreateThread(function()
    RequestAnimDict('anim@amb@nightclub@peds@')
    while not HasAnimDictLoaded('anim@amb@nightclub@peds@') do
        Citizen.Wait(0)
    end
end)
RegisterNetEvent('kzo_contract:useitem', function()
    local vehicle, distance = ESX.Game.GetClosestVehicle()
    local player, distancep = ESX.Game.GetClosestPlayer()
    if vehicle and distance < 3.5 and player ~= -1 and distancep < 3.5 then
        ESX.TriggerServerCallback('kzo_contract:getclosestplayername', function(name, playername)

            SetNuiFocus(true, true)
            SendNUIMessage({
                action = 'opencontract',
                plate = GetVehicleNumberPlateText(vehicle),
                name = name,
                playername = playername,
                closestid = GetPlayerServerId(player)
            })

        end, GetPlayerServerId(player))
    else
        ESX.ShowNotification('Không có xe hoặc người chơi nào ở gần bạn!', 'error')
    end
end)
RegisterNetEvent('kzo_contract:showAnim')
AddEventHandler('kzo_contract:showAnim', function(player)
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, true)
    Citizen.Wait(10000)
    ClearPedTasks(PlayerPedId())
end)