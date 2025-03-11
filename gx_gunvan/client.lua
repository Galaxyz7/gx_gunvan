local gunVan = nil
local vanBlip = nil
local ped = nil
local shopOpen = false
local gunVanPed = nil
local gunvanshop = nil
local model = 'speedo'
local pedModel = `s_m_y_dealer_01`
local Locationx = nil
local Locationy = nil
local Locationz  = nil



-- Function to update the van location
RegisterNetEvent("gunvan:updateLocation")
AddEventHandler("gunvan:updateLocation", function(newLocation, newgunvanshop)
    if DoesEntityExist(gunVan) then
        DeleteEntity(gunVan)
        gunVan = nil
    end
    if DoesEntityExist(gunVanPed) then
        DeleteEntity(gunVanPed)
        gunVanPed = nil
    end
    gunvanshop = newgunvanshop

    -- Load the model
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    Locationx, Locationy, Locationz = newLocation.x, newLocation.y, newLocation.z
    gunVan = CreateVehicle(model, newLocation.x, newLocation.y, newLocation.z, true, true)
    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(gunVan, true, true)
    SetVehicleOnGroundProperly(gunVan)
    SetEntityInvincible(gunVan, true)
    SetVehicleDirtLevel(gunVan, 0.0)
    SetVehicleDoorsLocked(gunVan, 2)
    SetEntityHeading(gunVan, newLocation.y)
    FreezeEntityPosition(gunVan, true)
    SetVehicleNumberPlateText(gunVan, 'GUN VAN')
    -- Update the global gunVanLocation to the new location
    gunVanLocation = GetEntityCoords(gunVan)

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(0)
    end

    -- Spawn the ped inside the van
    gunVanPed = CreatePedInsideVehicle(gunVan, 4, pedModel, -1, true, false)
    SetEntityInvincible(gunVanPed, true)
    SetBlockingOfNonTemporaryEvents(gunVanPed, true)
    
    
    -- Update the global gunVanLocation to the new location
    gunVanLocation = GetEntityCoords(gunVan)
    -- Load ped model

    
end)

-- Show Blip when within range
CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        if gunVan and DoesEntityExist(gunVan) then
            local vanCoords = GetEntityCoords(gunVan)
            local distance = #(playerCoords - vanCoords)

            if distance <= Config.BlipDistance then
                if not DoesBlipExist(vanBlip) then
                    vanBlip = AddBlipForCoord(vanCoords)
                    SetBlipSprite(vanBlip, 110)
                    SetBlipColour(vanBlip, 1)
                    SetBlipScale(vanBlip, 1.0)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Gun Van")
                    EndTextCommandSetBlipName(vanBlip)
                end
            else
                if DoesBlipExist(vanBlip) then
                    RemoveBlip(vanBlip)
                end
            end
        end
    end
end)

-- Handle shop interaction
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        if gunVan and DoesEntityExist(gunVan) then
            local vanCoords = GetEntityCoords(gunVan)
            local distance = #(playerCoords - vanCoords)

            if distance < 2.0 then  -- Check if the player is near the Gun Van
                DrawText3D(Locationx, Locationy, Locationz, "[E] Open Gun Van Shop")

                if IsControlJustReleased(0, 38) then -- Press "E" to open menu
                    -- Trigger the context menu to open shop UI

                    exports.ox_inventory:openInventory('shop', { type = gunvanshop})


                end
            end
        end
    end
end)

-- Function to draw 3D Text (for showing the "Press E to open menu")
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
