local itemname = 'contract'
ESX.RegisterServerCallback('kzo_contract:getclosestplayername', function(source, cb, closestid)
    local xName = GetPlayerName(source)
    local closestName = GetPlayerName(closestid)
    cb(xName, closestName)
end)
ESX.RegisterUsableItem(itemname, function(source)
    TriggerClientEvent("kzo_contract:useitem", source)
end)
RegisterNetEvent('kzo_contract:writecontact', function(closestplayer, plate)
    local src = source
    local target = closestplayer
    local xPlayer = ESX.GetPlayerFromId(src)
    local closestPlayer = ESX.GetPlayerFromId(target)
    local xidentifier = xPlayer.identifier
    local tidentifier = closestPlayer.identifier
    TriggerClientEvent('kzo_contract:showAnim', src)
    Wait(11000)
    TriggerClientEvent('kzo_contract:showAnim', target)
    Wait(11000)
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate", {
        ["@plate"] = plate,
        ["@identifier"] = xidentifier
    }, function(result)
        print(xidentifier, plate)
        if result[1] ~= nil then
            if xPlayer.removeInventoryItem(itemname, 1) then
            MySQL.Sync.execute(
                'UPDATE owned_vehicles SET owner = @target WHERE plate = @plate',
                {
                    ['@target'] = tidentifier,
                    ['@plate'] = plate,
                })
                TriggerClientEvent("esx:showNotification", src, "The vehicle with license plate " .. plate .. " has been transferred to " .. GetPlayerName(target) .. "!", "success")
                TriggerClientEvent("esx:showNotification", target, "The vehicle with license plate " .. plate .. " has been transferred to you by " .. GetPlayerName(src) .. "!", "success")
            end
        else
            TriggerClientEvent("esx:showNotification", src, "The vehicle with license plate " .. plate .. " is not yours!", "error")
        end
    end)
end)