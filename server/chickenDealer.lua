local dealerPed = nil
local dealerNetID = nil

RegisterServerEvent('bm-chickenjob:SpawnDealerPed', function()
  DebugPrint('bm-chickenjob:SetDealerPed')
  local model = Config.Locations.chickenDealer.PedModel
  local coords = Config.Locations.chickenDealer.coords
  local h = Config.Locations.chickenDealer.PedModelHeading
  dealerPed = CreatePed(0, model, coords, h, true, false)
  dealerNetID = NetworkGetNetworkIdFromEntity(dealerPed)
  TriggerClientEvent('bm-chickenjob:AssignNewChickenDealerEnt', -1 , dealerNetID)
end)

QBCore.Functions.CreateCallback('bm-chickenjob:GetDealerPed',
  function(_, cb)
    DebugPrint2('bm-chickenjob:GetDealerPed: ', dealerNetID)
    cb(dealerNetID)
  end)

function GetDealerNetID()
  DebugPrint('GetDealerNetID()')
  return dealerNetID
end

CreateThread(function()
  while true do
    while not dealerPed do
      TriggerEvent('bm-chickenjob:SpawnDealerPed')
      Wait(100)
    end
    Wait(5000)
    if dealerPed then
      local c  = GetEntityCoords(dealerPed)
      local distdiff = #(c - Config.Locations.chickenDealer.coords)
      if distdiff> 5 then
        DeleteEntity(dealerPed)
        TriggerEvent('bm-chickenjob:SpawnDealerPed')
      end
      if GetPedSourceOfDeath(dealerPed) ~= 0 then
        DeleteEntity(dealerPed)
        TriggerEvent('bm-chickenjob:SpawnDealerPed')
      end
  end
  end
end)

print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5chickenDealer^7")
