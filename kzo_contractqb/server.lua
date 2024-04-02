QBCore = exports['qb-core']:GetCoreObject()
local itemname = 'contract'
QBCore.Functions.CreateCallback('kzo_contract:getclosestplayername', function(source, cb, closestid)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local closestPlayer = QBCore.Functions.GetPlayer(closestid)
    local xName = xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    local closestName = closestPlayer.PlayerData.charinfo.firstname .. ' ' .. closestPlayer.PlayerData.charinfo.lastname
    cb(xName, closestName)
end)
QBCore.Functions.CreateUseableItem(itemname, function(source, item)
    TriggerClientEvent("kzo_contract:useitem", source)
end)
RegisterNetEvent('kzo_contract:writecontact', function(closestplayer, plate)
    local src = source
    local target = closestplayer
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local closestPlayer = QBCore.Functions.GetPlayer(target)
    local xCitizen = xPlayer.PlayerData.citizenid
    local tCitizen = closestPlayer.PlayerData.citizenid
    local tidentifier = closestPlayer.PlayerData.license
    local xName = xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    local closestName = closestPlayer.PlayerData.charinfo.firstname .. ' ' .. closestPlayer.PlayerData.charinfo.lastname
    TriggerClientEvent('kzo_contract:showAnim', src)
    Wait(11000)
    TriggerClientEvent('kzo_contract:showAnim', target)
    Wait(11000)
    MySQL.Async.fetchAll("SELECT * FROM player_vehicles WHERE plate = @plate AND citizenid = @citizen", {
        ["@plate"] = plate,
        ["@citizen"] = xCitizen
    }, function(result)
        if result[1] ~= nil then
            if xPlayer.Functions.RemoveItem(itemname, 1) then
            MySQL.Sync.execute(
                'UPDATE `player_vehicles` SET license = @license, citizenid = @citizenid WHERE plate = @plate',
                {
                    ['@license'] = tidentifier,
                    ['@citizenid'] = tCitizen,
                    ['@plate'] = plate,
                })
                TriggerClientEvent("QBCore:Notify", src, "The vehicle with license plate " .. plate .. " has been transferred to " .. closestName .. "!", "success")
                TriggerClientEvent("QBCore:Notify", target, "The vehicle with license plate " .. plate .. " has been transferred to you by " .. xName .. "!", "success")
                TriggerClientEvent("vehiclekeys:client:SetOwner", target, plate)
            end
        else
            TriggerClientEvent("QBCore:Notify", src, "The vehicle with license plate " .. plate .. " is not yours!", "error")
        end
    end)
end)
