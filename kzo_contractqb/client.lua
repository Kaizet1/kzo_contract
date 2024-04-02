QBCore = exports['qb-core']:GetCoreObject()
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
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    local player, distancep = QBCore.Functions.GetClosestPlayer()
    if vehicle ~= -1 and distance < 3.5 and player ~= -1 and distancep < 3.5 then
        QBCore.Functions.TriggerCallback('kzo_contract:getclosestplayername', function(name, playername)

            SetNuiFocus(true, true)
            SendNUIMessage({
                action = 'opencontract',
                plate = QBCore.Functions.GetPlate(vehicle),
                name = name,
                playername = playername,
                closestid = GetPlayerServerId(player),
            })

        end, GetPlayerServerId(player))
    else
        QBCore.Functions.Notify('Không có xe hoặc người chơi nào ở gần bạn!', 'error')
    end
end)
RegisterNetEvent('kzo_contract:showAnim')
AddEventHandler('kzo_contract:showAnim', function(player)
	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, true)
	Citizen.Wait(10000)
	ClearPedTasks(PlayerPedId())
end)

