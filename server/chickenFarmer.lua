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

function GetFarmerNetID()
  return FarmerNetID
end

    end
    end
  end)
