QBCore = exports['qb-core']:GetCoreObject()

IsPacking = false
IsPortioningChicken = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
  StartUp()
end)

AddEventHandler('onResourceStart', function(resourceName)
  if GetCurrentResourceName() ~= resourceName then return end
  StartUp()
end)

function StartUp()
  SetUpBlips()
  if Config.UseQBTarget then
    SetUpQBTargetWorkAreas()
  else
    FarmMarker()
    FactoryMarkers()
    DealerMarker()
  end
end

print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5Client^7")
