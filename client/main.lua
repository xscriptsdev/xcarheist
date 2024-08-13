ESX = exports["es_extended"]:getSharedObject()

local pedModel = Config.pedModel
local pedCoords = Config.PedLocation
local transportVehicle = Config.TransportVehicle
local transportLocation = Config.TransportVehicleLocation


RequestModel(pedModel)
while not HasModelLoaded(pedModel) do
    Wait(1)
end

local ped = CreatePed(4, pedModel, pedCoords.x, pedCoords.y, pedCoords.z, pedCoords.heading, false, true)
SetEntityAsMissionEntity(ped, true, true)
FreezeEntityPosition(ped, true)
SetBlockingOfNonTemporaryEvents(ped, true)

if Config.ShowPedBlip then
    local pedBlip = AddBlipForCoord(pedCoords.x, pedCoords.y, pedCoords.z)
    SetBlipSprite(pedBlip, 1)
    SetBlipDisplay(pedBlip, 4)
    SetBlipScale(pedBlip, 1.0)
    SetBlipColour(pedBlip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Car Theft Ped")
    EndTextCommandSetBlipName(pedBlip)
end

local currentVehicle = nil
local jobActive = false
local vehicleBlip = nil
local vehicleLocation = nil
local vehicleModel = nil
local rewardAmount = 0
local notificationSent = false
local transportVehicleInstance = nil

exports.ox_target:addLocalEntity(ped, {
    {
        name = 'car_heist_menu',
        label = 'Interact with Ped',
        icon = 'fas fa-car',
        onSelect = function(data)
            TriggerEvent('showCarHeistMenu')
        end,
    }
})

RegisterNetEvent('showCarHeistMenu', function()
    lib.registerContext({
        id = 'car_heist_menu',
        title = 'Car Heist',
        menu = 'car_heist_menu',
        options = {
            {
                title = 'Start Job',
                onSelect = function()
                    TriggerEvent('x-carheist:startJob')
                end
            },
            {
                title = 'Complete Job',
                onSelect = function()
                    TriggerEvent('x-carheist:returnCar')
                end
            },
            {
                title = 'Cancel Job',
                onSelect = function()
                    TriggerEvent('x-carheist:cancelJob')
                end
            }
        }
    })

    lib.showContext('car_heist_menu')
end)

RegisterNetEvent('x-carheist:startJob')
AddEventHandler('x-carheist:startJob', function()
    if jobActive then
        TriggerEvent('ox_lib:notify', {title = 'Job Already Active', description = 'You already have an active job.', type = 'error'})
        return
    end

    local transportVehicleHash = GetHashKey(transportVehicle)
    RequestModel(transportVehicleHash)
    while not HasModelLoaded(transportVehicleHash) do
        Wait(1)
    end

    transportVehicleInstance = CreateVehicle(transportVehicleHash, transportLocation.x, transportLocation.y, transportLocation.z, transportLocation.heading, true, false)
    SetEntityAsMissionEntity(transportVehicleInstance, true, true)

    SetVehicleDoorsLocked(transportVehicleInstance, 1) 

    local index = math.random(#Config.VehicleLocations)
    vehicleLocation = Config.VehicleLocations[index]
    vehicleModel = Config.VehicleModels[index]
    rewardAmount = Config.RewardAmount[index]

    local vehicleHash = GetHashKey(vehicleModel)
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Wait(1)
    end

    currentVehicle = CreateVehicle(vehicleHash, vehicleLocation.x, vehicleLocation.y, vehicleLocation.z, vehicleLocation.heading, true, false)
    SetEntityAsMissionEntity(currentVehicle, true, true)
    SetVehicleDoorsLocked(currentVehicle, 2) 

    SetNewWaypoint(vehicleLocation.x, vehicleLocation.y)

    if vehicleBlip then
        RemoveBlip(vehicleBlip)
    end

    vehicleBlip = AddBlipForCoord(vehicleLocation.x, vehicleLocation.y, vehicleLocation.z)
    SetBlipSprite(vehicleBlip, 225)
    SetBlipDisplay(vehicleBlip, 4)
    SetBlipScale(vehicleBlip, 1.0)
    SetBlipColour(vehicleBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vehicle to Steal")
    EndTextCommandSetBlipName(vehicleBlip)

    TriggerEvent('ox_lib:notify', {title = 'Job Started', description = 'Go to the marked location and steal the vehicle.', type = 'info'})

    jobActive = true
end)

RegisterNetEvent('x-carheist:returnCar')
AddEventHandler('x-carheist:returnCar', function()
    if not jobActive then
        TriggerEvent('ox_lib:notify', {title = 'No Active Job', description = 'You have no active job to complete.', type = 'error'})
        return
    end

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == currentVehicle then
        TriggerServerEvent('x-carheist:completeJob', rewardAmount)
        DeleteVehicle(currentVehicle)
        currentVehicle = nil
        jobActive = false

        if vehicleBlip then
            RemoveBlip(vehicleBlip)
        end

        if transportVehicleInstance then
            DeleteVehicle(transportVehicleInstance)
            transportVehicleInstance = nil
        end

        TriggerEvent('ox_lib:notify', {title = 'Job Completed', description = 'You have returned the vehicle and received your reward.', type = 'success'})
    else
        TriggerEvent('ox_lib:notify', {title = 'Wrong Vehicle', description = 'You must return the vehicle you stole.', type = 'error'})
    end
end)

RegisterNetEvent('x-carheist:cancelJob')
AddEventHandler('x-carheist:cancelJob', function()
    if not jobActive then
        TriggerEvent('ox_lib:notify', {title = 'No Active Job', description = 'You have no active job to cancel.', type = 'error'})
        return
    end

    if currentVehicle then
        DeleteVehicle(currentVehicle)
        currentVehicle = nil
    end

    if transportVehicleInstance then
        DeleteVehicle(transportVehicleInstance)
        transportVehicleInstance = nil
    end

    if vehicleBlip then
        RemoveBlip(vehicleBlip)
        vehicleBlip = nil
    end

    ClearGpsPlayerWaypoint()
    DeleteWaypoint()

    Citizen.CreateThread(function()
        Citizen.Wait(500) 
        ClearGpsPlayerWaypoint() 
        DeleteWaypoint()
    end)

    jobActive = false

    TriggerEvent('ox_lib:notify', {title = 'Job Canceled', description = 'The job has been canceled.', type = 'error'})
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        if jobActive and currentVehicle then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if vehicle == currentVehicle then
                if not notificationSent then
                    TriggerEvent('ox_lib:notify', {title = 'Vehicle Ready', description = 'You got the vehicle? Please hurry and bring me the vehicle!!!', type = 'info'})
                    notificationSent = true
                end

                SetNewWaypoint(pedCoords.x, pedCoords.y)

                Citizen.Wait(10000)
            else
                notificationSent = false
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local peds = GetPedsInArea(pedCoords.x, pedCoords.y, pedCoords.z, 10.0)
        for _, ped in pairs(peds) do
            if IsPedAPlayer(ped) then
                SetEntityInvincible(ped, true)
                SetPlayerInvincible(GetPlayerPed(-1), true)
            end
        end
    end
end)

function GetPedsInArea(x, y, z, radius)
    local peds = {}
    local handle, ped = FindFirstPed()
    local success
    repeat
        local pedCoords = GetEntityCoords(ped)
        if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, x, y, z) < radius then
            table.insert(peds, ped)
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return peds
end
