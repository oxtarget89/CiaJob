	ESX = exports['es_extended']:getSharedObject()


local jobPlayers = {}
local bodyCams = {}
local carCams  = {}

-----------------------------------------------------------------------------------------
-- EVENT'S --
-----------------------------------------------------------------------------------------

RegisterNetEvent('wais:playerLoaded:bodycam', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if Player.job.name == 'cia' then
        if jobPlayers[tostring(src)] == nil then
            jobPlayers[tostring(src)] = false
        end
        TriggerClientEvent('wais:body:pload', src, bodyCams, carCams)
    end
end)

RegisterNetEvent('wais:jobCheck', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if Player.job.name == 'cia' then
        if jobPlayers[tostring(src)] == nil then
            jobPlayers[tostring(src)] = false
        end
    else
        if jobPlayers[tostring(src)] ~= nil then
            jobPlayers[tostring(src)] = nil
            if bodyCams[tostring(src)] ~= nil then
                bodyCams[tostring(src)] = nil
                TriggerJob(true, tostring(src), false)
            end
        end
    end
end)

RegisterNetEvent('wais:closeBodyCam:Inventory', function(source)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if jobPlayers[tostring(src)] then
        jobPlayers[tostring(src)] = false
        if bodyCams[tostring(src)] ~= nil then
            bodyCams[tostring(src)] = nil
            TriggerJob(true, tostring(src), false)
            TriggerClientEvent('esx:showNotification', src, Config.Lang["bodycam-off"])
        end
    end
end)

RegisterNetEvent('wais:addDashCam', function(carId, plate, boneId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    
    if carCams[carId] == nil then
        TriggerClientEvent('esx:showNotification', src, Config.Lang["dashcam-on"])
        carCams[carId] = {bone = boneId, plate = plate, names = Player.variables.firstName .. ' ' .. Player.variables.lastName}
        TriggerJob(false, carId, true)
    else
        TriggerClientEvent('esx:showNotification', src, Config.Lang["dashcam-off"])
        TriggerEvent('wais:removeTable:DashCam:s', tostring(carId))
    end
end)

RegisterNetEvent('wais:removeTable:DashCam:s', function(tableId)
    if carCams[tableId] ~= nil then
        carCams[tableId] = nil
        TriggerJob(false, tableId, false)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if jobPlayers[tostring(src)] ~= nil then
        jobPlayers[tostring(src)] = nil
        if bodyCams[tostring(src)] ~= nil then
            bodyCams[tostring(src)] = nil
            TriggerJob(true, tostring(src), false)
        end
    end
end)

-----------------------------------------------------------------------------------------
-- CALLBACK'S --
-----------------------------------------------------------------------------------------

ESX.RegisterServerCallback('wais:getCoords', function(source, cb, id)
    local ped = GetPlayerPed(id)
    local playerCoords = GetEntityCoords(ped)
    cb(playerCoords)
end)

ESX.RegisterServerCallback('wais:getCoordsCar', function(source, cb, id)
    local coords = GetEntityCoords(NetworkGetEntityFromNetworkId(id))
    cb(coords)
end)

ESX.RegisterUsableItem(Config.Items.bodycam, function(source, item)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if jobPlayers[tostring(src)] ~= nil then
        if not jobPlayers[tostring(src)] then
            jobPlayers[tostring(src)] = true
            if bodyCams[tostring(src)] == nil then
                bodyCams[tostring(src)] = {gradeLabel = Player.job.grade_label, names = Player.variables.firstName .. ' ' .. Player.variables.lastName}
                TriggerJob(true, tostring(src), true)
                TriggerClientEvent('esx:showNotification', src, Config.Lang["bodycam-on"])
            end
        else
            jobPlayers[tostring(src)] = false
            if bodyCams[tostring(src)] ~= nil then
                bodyCams[tostring(src)] = nil
                TriggerJob(true, tostring(src), false)
                TriggerClientEvent('esx:showNotification', src, Config.Lang["bodycam-off"])
            end
        end
    end
end)

ESX.RegisterUsableItem(Config.Items.dashcam, function(source, item)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if jobPlayers[tostring(src)] ~= nil then
        TriggerClientEvent('wais:AddOrRemove:DashCam', src)
    end
end)

-----------------------------------------------------------------------------------------
-- FUNCTION'S --
-----------------------------------------------------------------------------------------

function TriggerJob(bodyCam, tableId, add)
    if bodyCam then
        for k, v in pairs(jobPlayers) do
            if add then
                TriggerClientEvent('wais:addTable:BodyCam', k, tableId, bodyCams[tableId])
            else
                TriggerClientEvent('wais:removeTable:BodyCam', k, tableId)
            end
        end
    else
        for k, v in pairs(jobPlayers) do
            if add then
                TriggerClientEvent('wais:addTable:DashCam', k, tableId, carCams[tableId])
            else
                TriggerClientEvent('wais:removeTable:DashCam', k, tableId)
            end
        end
    end
end

-----------------------------------------------------------------------------------------
-- COMMAND'S --
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
-- THREAD'S --
-----------------------------------------------------------------------------------------

local resource  = GetInvokingResource() or GetCurrentResourceName()
local script    = GetResourceMetadata(resource, 'scriptname', 0)
local version   = GetResourceMetadata(resource, 'version', 0)
local newversion

SetTimeout(1000, function()
    checkversion()
end)

function checkversion()
    PerformHttpRequest('http://213.238.172.182/index.php?sc='..script, function(errorCode, resultData, resultHeaders)
        if resultData ~= nil then
            newversion = resultData:gsub("\r", "")
            newversion = newversion:gsub("\n", "")
            newversion = string.sub(newversion, 4)
        
            if newversion == "nodata" then return end

            if newversion == "error" or newversion == "dontfind" then
                CreateThread(function()
                    while true do
                        print('^3This script could not be found. Please restore the script name or fxmanifest information.')
                        Wait(20 * 1000)
                    end
                end)
            end
        else
            print('^3Don\'t control this script version. Have a problem. Try again now..')
            Wait(5000)
            checkversion()
        end
    end)
end

