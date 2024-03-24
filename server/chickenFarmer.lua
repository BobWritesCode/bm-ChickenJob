local farmerPed = nil
local farmerNetId = nil

RegisterServerEvent('bm-chickenjob:SpawnFarmerPed', function()
  DebugPrint2('Called: ', 'bm-chickenjob:SpawnFarmerPed')
  local model = Config.Locations.chickenFarm.PedModel
  local coords = Config.Locations.chickenFarm.coords
  local h = Config.Locations.chickenFarm.PedModelHeading
  farmerPed = CreatePed(0, model, coords, h, true, false)
  farmerNetId = NetworkGetNetworkIdFromEntity(farmerPed)
  DebugPrint2('farmerPed: ', farmerPed)
  DebugPrint2('FarmerNetID: ', farmerNetId)
  TriggerClientEvent('bm-chickenjob:AssignNewChickenFarmerEnt', -1, farmerNetId)
end)

function GetFarmerNetID()
  DebugPrint2('Called: ', 'GetFarmerNetIDd')
  return farmerNetId
end

local function DeleteAndSpawnFarmer()
  DebugPrint2('Called: ', 'DeleteAndSpawnFarmer')
  DebugPrint2('farmerPed:', farmerPed)
  DeleteEntity(farmerPed)
  TriggerEvent('bm-chickenjob:SpawnFarmerPed')
end

CreateThread(function()
  while true do
    while not farmerPed do
      TriggerEvent('bm-chickenjob:SpawnFarmerPed')
      Wait(100)
    end
    Wait(5000)
    if farmerPed then
      local c = GetEntityCoords(farmerPed)
      local distdiff = #(c - Config.Locations.chickenFarm.coords)
      if distdiff > 5 or GetPedSourceOfDeath(farmerPed) ~= 0 then
        DeleteAndSpawnFarmer()
      end
    end
  end
end)

print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5chickenFarmer^7")
