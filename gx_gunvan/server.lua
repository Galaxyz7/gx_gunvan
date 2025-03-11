ESX = exports["es_extended"]:getSharedObject()

local currentVanLocation = nil
local currentShopItems = {}

local gunVan = nil
local vanBlip = nil
local ped = nil
local gunVanPed = nil
local shopOpen = false
local model = 'speedo'
local gunvanshop = nil

-- Function to pick a new van location
local function UpdateVanLocation()
    local newLocation = Config.Locations[math.random(#Config.Locations)]
    currentVanLocation = newLocation
    local negunvanshop = Config.Items[math.random(#Config.Items)]
    gunvanshop = negunvanshop
    --update shop
    -- Send OX notification to players
    TriggerClientEvent("ox_lib:notify", -1, {
        title = "Gun Van",
        description = Config.NotifyMessage,
        type = "info"
    })
end




-- Initialize the script with a location & shop
UpdateVanLocation()


ESX.RegisterCommand("gunvan", "admin", function(xPlayer, args, showError)
    local source = xPlayer.source
    local ped = GetPlayerPed(source)
    local heading = GetEntityHeading(ped)
    local forwardVector = vector3(math.cos(math.rad(heading)), math.sin(math.rad(heading)), 0.0)
    local spawnCoords = GetEntityCoords(ped) + (forwardVector * 20.0) -- 20 meters in front

    currentVanLocation = { x = spawnCoords.x, y = spawnCoords.y, z = spawnCoords.z }
    TriggerClientEvent("gunvan:updateLocation", -1, currentVanLocation, gunvanshop)
    -- Notify all players
    TriggerClientEvent("ox_lib:notify", -1, {
        title = "Gun Van",
        description = "The Gun Van has moved to a new location!",
        type = "info"
    })

    -- Notify admin
    TriggerClientEvent("ox_lib:notify", source, {
        title = "Gun Van",
        description = "You have spawned the Gun Van 20m ahead of you.",
        type = "success"
    })
end, false)


ESX.RegisterCommand("gunvanupdate", "admin", function(xPlayer, args, showError)
    local source = xPlayer.source

    UpdateVanLocation()
    TriggerClientEvent("gunvan:updateLocation", -1, currentVanLocation, gunvanshop)
    -- Notify all players
    TriggerClientEvent("ox_lib:notify", -1, {
        title = "Gun Van",
        description = "The Gun Van has moved to a new location!",
        type = "info"
    })

    -- Notify admin
    TriggerClientEvent("ox_lib:notify", source, {
        title = "Gun Van",
        description = "You have spawned the Gun Van 20m ahead of you.",
        type = "success"
    })
end, false)
