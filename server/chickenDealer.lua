local DealerPed = nil
local DealerNetID = nil

RegisterServerEvent('bm-chickenjob:SpawnDealerPed', function()
  DebugPrint('bm-chickenjob:SetDealerPed')
  local model = Config.Locations.chickenDealer.PedModel
  local coords = Config.Locations.chickenDealer.coords
  local h = Config.Locations.chickenDealer.PedModelHeading
  DealerPed = CreatePed(0, model, coords, h, true, false)
  DealerNetID = NetworkGetNetworkIdFromEntity(DealerPed)
  TriggerClientEvent('bm-chickenjob:AssignNewChickenDealerEnt', -1 , DealerNetID)
end)

QBCore.Functions.CreateCallback('bm-chickenjob:GetDealerPed',
  function(_, cb)
    DebugPrint2('bm-chickenjob:GetDealerPed: ', DealerNetID)
    cb(DealerNetID)
  end)

  CreateThread(function()
    while true do
      while not DealerPed do
        TriggerEvent('bm-chickenjob:SpawnDealerPed')
        Wait(100)
      end
      Wait(5000)
      if DealerPed then
        local c  = GetEntityCoords(DealerPed)
        local distdiff = #(c - Config.Locations.chickenDealer.coords)
        if distdiff> 5 then
          DeleteEntity(DealerPed)
          TriggerEvent('bm-chickenjob:SpawnDealerPed')
        end
        if GetPedSourceOfDeath(DealerPed) ~= 0 then
          DeleteEntity(DealerPed)
          TriggerEvent('bm-chickenjob:SpawnDealerPed')
        end
    end
    end
  end)
