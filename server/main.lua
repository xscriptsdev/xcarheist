ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('x-carheist:completeJob')
AddEventHandler('x-carheist:completeJob', function(rewardAmount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addMoney(rewardAmount)
        TriggerClientEvent('ox_lib:notify', source, {title = 'Job Completed', description = 'You have received $' .. rewardAmount, type = 'success'})
    else
       
    end
end)

if Config.UsingXlockpick then
    if GetResourceState(Config.LockpickResourceName) == 'started' then
        print("Using the resource: " .. Config.LockpickResourceName .. " for lockpicking.")
    else
        print("The resource: " .. Config.LockpickResourceName .. " is not started.")
    end
else
    print("Not using X lockpick, using alternative lockpick system sadly.")
end

