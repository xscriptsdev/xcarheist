--██╗░░██╗  ░██████╗░█████╗░██████╗░██╗██████╗░████████╗░██████╗
--╚██╗██╔╝  ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
--░╚███╔╝░  ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░╚█████╗░
--░██╔██╗░  ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░░╚═══██╗
--██╔╝╚██╗  ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░██████╔╝
--╚═╝░░╚═╝  ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░╚═════╝░
-- Support: https://discord.gg/N74Yuq9ARQ

Config = {

    pedModel = 's_m_y_dealer_01', -- model of the ped if u want to choose a diffrent one choose it from here: https://docs.fivem.net/docs/game-references/ped-models/
    
    PedLocation = {
        x = 449.34, y = -574.105, z = 27.70, heading = 165.0 -- location of the ped
    },

    ShowPedBlip = true, -- if u want to blip to be on the map of the ped set it to true if u don't set it to false

    TransportVehicle = 'youga', -- model of transport vehicle 

    UsingXlockpick = true, -- if u are using xlockpick set it to true if u are using other lockpick system set it to false
    LockpickResourceName = 'x-lockpicksystem', -- resource name of X Lockpick System / if u are using other lockpick system u leave it like a default will not make any diffrence.

    TransportVehicleLocation = {
        x = 451.73, y = -579.74, z = 28.499, heading = 73.20 -- spawn for the transport vehicle
    },

    -- locations for steal vehicles
    VehicleLocations = {
        {x = -115.42, y = 33.37, z = 71.31, heading = 256.20},  --  location 1
        {x = 398.14, y = 62.77, z = 97.97, heading = 133.13}, -- location 2
        {x = 398.14, y = 62.77, z = 97.97, heading = 133.13}, -- location 3
        {x = -756.12, y = -1076.64, z = 11.82, heading = 21.94}, -- location 4 
        {x = -5.8839, y = -1515.25, z = 29.71, heading = 317.30} -- location 5 

    },

    -- vehicle models
    VehicleModels = {
        'adder', -- for location 1
        'banshee', -- for location 2
        'bullet', -- for location 3
        'entityxf', -- for location 4
        'infernus' -- for location 5
    },

    RewardAmount = {
        1500, -- for location 1
        2000, -- for location 2
        1800, -- for location 3
        1700, -- for location 4
        2200 -- for location 5
    },

    LocationChances = {
        20,-- for location 1
        30, -- for location 2
        10, -- for location 3
        20, -- for location 4
        20 -- for location 5
    }
}
