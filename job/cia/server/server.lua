-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
cuffedPlayers = {}

CreateThread(function()
    while ESX == nil do Wait(1000) end
    for i=1, #Config.ciaJobs do
        TriggerEvent('esx_society:registerSociety', Config.ciaJobs[i], Config.ciaJobs[i], 'society_'..Config.ciaJobs[i], 'society_'..Config.ciaJobs[i], 'society_'..Config.ciaJobs[i], {type = 'public'})
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    if cuffedPlayers[playerId] then
        cuffedPlayers[playerId] = nil
    end
end)

TriggerEvent('esx_society:registerSociety', 'cia', 'cia', 'society_cia', 'society_cia', 'society_cia', {type = 'public'})

RegisterServerEvent('rom_cia:attemptTackle')
AddEventHandler('rom_cia:attemptTackle', function(targetId)
    TriggerClientEvent('rom_cia:tackled', targetId, source)
    TriggerClientEvent('rom_cia:tackle', source)
end)

RegisterServerEvent('rom_cia:escortPlayer')
AddEventHandler('rom_cia:escortPlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasJob
    for i=1, #Config.ciaJobs do
        if xPlayer.job.name == Config.ciaJobs[i] then
            hasJob = xPlayer.job.name
            break
        end
    end
    if hasJob then
        TriggerClientEvent('rom_cia:setEscort', source, targetId)
        TriggerClientEvent('rom_cia:escortedPlayer', targetId, source)
    end
end)

RegisterServerEvent('rom_cia:inVehiclePlayer')
AddEventHandler('rom_cia:inVehiclePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasJob
    for i=1, #Config.ciaJobs do
        if xPlayer.job.name == Config.ciaJobs[i] then
            hasJob = xPlayer.job.name
            break
        end
    end
    if hasJob then
        TriggerClientEvent('rom_cia:stopEscorting', source)
        TriggerClientEvent('rom_cia:putInVehicle', targetId)
    end
end)

RegisterServerEvent('rom_cia:outVehiclePlayer')
AddEventHandler('rom_cia:outVehiclePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasJob
    for i=1, #Config.ciaJobs do
        if xPlayer.job.name == Config.ciaJobs[i] then
            hasJob = xPlayer.job.name
            break
        end
    end
    if hasJob then
        TriggerClientEvent('rom_cia:takeFromVehicle', targetId)
    end
end)

RegisterServerEvent('rom_cia:setCuff')
AddEventHandler('rom_cia:setCuff', function(isCuffed)
    cuffedPlayers[source] = isCuffed
end)

RegisterServerEvent('rom_cia:handcuffPlayer')
AddEventHandler('rom_cia:handcuffPlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasJob
    for i=1, #Config.ciaJobs do
        if xPlayer.job.name == Config.ciaJobs[i] then
            hasJob = xPlayer.job.name
            break
        end
    end
    if hasJob then
        if cuffedPlayers[target] then
            TriggerClientEvent('rom_cia:uncuffAnim', source, target)
            Wait(4000)
            TriggerClientEvent('rom_cia:uncuff', target)
        else
            TriggerClientEvent('rom_cia:arrested', target, source)
            TriggerClientEvent('rom_cia:arrest', source)
        end
    end
end)

getciaOnline = function()
    local players = ESX.GetPlayers()
    local count = 0
    for i = 1, #players do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        for i=1, #Config.ciaJobs do
            if xPlayer.job.name == Config.ciaJobs[i] then
                count = count + 1
            end
        end
    end
    return count
end

exports('getciaOnline', getciaOnline)

lib.callback.register('rom_cia:getJobLabel', function(source, job)
    if ESX.Jobs?[job]?.label then
        return ESX.Jobs[job].label
    else
        return Strings.cia -- If for some reason ESX.Jobs is malfunctioning(Must love ESX...)
    end
end)

lib.callback.register('rom_cia:isCuffed', function(source, target)
    if cuffedPlayers[target] then
        return true
    else
        return false
    end
end)

lib.callback.register('rom_cia:getVehicleOwner', function(source, plate)
    local owner
    MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            local identifier = result[1].owner
            MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
                ['@identifier'] = identifier
            }, function(result2)
                if result2[1] then
                    owner = result2[1].firstname..' '..result2[1].lastname
                else
                    owner = false
                end
            end)
        else
            owner = false
        end
    end)
    while owner == nil do
        Wait()
    end
    return owner
end)

lib.callback.register('rom_cia:canPurchase', function(source, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemData
    if data.grade > #Config.Locations[data.id].armoury.weapons then
        itemData = Config.Locations[data.id].armoury.weapons[#Config.Locations[data.id].armoury.weapons][data.itemId]
    elseif not Config.Locations[data.id].armoury.weapons[data.grade] then
        print('[rom_cia] : Armory not set up properly for job grade: '..data.grade)
    else
        itemData = Config.Locations[data.id].armoury.weapons[data.grade][data.itemId]
    end
    if not itemData.price then
        if not Config.weaponsAsItems then
            if data.itemId:sub(0, 7) == 'WEAPON_' then
                xPlayer.addWeapon(data.itemId, 200)
            else
                xPlayer.addInventoryItem(data.itemId, data.quantity)
            end
        else
            xPlayer.addInventoryItem(data.itemId, data.quantity)
        end
        return true
    else
        local xmoney = xPlayer.getAccount('money').money
        if xmoney < itemData.price then
            return false
        else
            xPlayer.removeAccountMoney('money', itemData.price)
            if not Config.weaponsAsItems then
                if data.itemId:sub(0, 7) == 'WEAPON_' then
                    xPlayer.addWeapon(data.itemId, 200)
                else
                    xPlayer.addInventoryItem(data.itemId, data.quantity)
                end
            else
                xPlayer.addInventoryItem(data.itemId, data.quantity)
            end
            return true
        end
    end
end)
