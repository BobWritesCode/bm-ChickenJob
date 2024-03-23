local farmerPed = nil
local farmerNetID = nil

RegisterServerEvent('bm-chickenjob:SpawnFarmerPed', function()
  DebugPrint('bm-chickenjob:SetFarmerPed')
  local model = Config.Locations.chickenFarm.PedModel
  local coords = Config.Locations.chickenFarm.coords
  local h = Config.Locations.chickenFarm.PedModelHeading
  farmerPed = CreatePed(0, model, coords, h, true, false)
  farmerNetID = NetworkGetNetworkIdFromEntity(farmerPed)
  TriggerClientEvent('bm-chickenjob:AssignNewChickenFarmerEnt', -1 , farmerNetID)
end)

QBCore.Functions.CreateCallback('bm-chickenjob:GetFarmerPed',
  function(_, cb)
    DebugPrint2('bm-chickenjob:GetFarmerPed: ', farmerNetID)
    cb(farmerNetID)
  end)

  CreateThread(function()
    while true do
      while not farmerPed do
        TriggerEvent('bm-chickenjob:SpawnFarmerPed')
        Wait(100)
      end
      Wait(5000)
      if farmerPed then
        local c  = GetEntityCoords(farmerPed)
        local distdiff = #(c - Config.Locations.chickenFarm.coords)
        if distdiff> 5 then
          DeleteEntity(farmerPed)
          TriggerEvent('bm-chickenjob:SpawnFarmerPed')
        end
        if GetPedSourceOfDeath(farmerPed) ~= 0 then
          DeleteEntity(farmerPed)
          TriggerEvent('bm-chickenjob:SpawnFarmerPed')
        end
    end
    end
  end)
