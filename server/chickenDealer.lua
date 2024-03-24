local dealerPed = nil
local dealerNetId = nil

RegisterServerEvent('bm-chickenjob:SpawnDealerPed', function()
  DebugPrint2('Called: ', 'bm-chickenjob:SpawnDealerPed')
  local model = Config.Locations.chickenDealer.PedModel
  local coords = Config.Locations.chickenDealer.coords
  local h = Config.Locations.chickenDealer.PedModelHeading
  dealerPed = CreatePed(0, model, coords, h, true, false)
  dealerNetId = NetworkGetNetworkIdFromEntity(dealerPed)
  DebugPrint2('dealerPed: ', dealerPed)
  DebugPrint2('dealerNetID: ', dealerNetId)
  TriggerClientEvent('bm-chickenjob:AssignNewChickenDealerEnt', -1, dealerNetId)
end)

function GetDealerNetID()
  DebugPrint2('Called: ', 'GetDealerNetID')
  return dealerNetId
end

local function DeleteAndSpawnDealer()
  DebugPrint2('Called: ', 'DeleteAndSpawnDealer')
  DebugPrint2('dealerPed:', dealerPed)
  local doesEntityExist = DoesEntityExist(dealerPed)
  DebugPrint2('doesEntityExist:', doesEntityExist)
  if doesEntityExist then
    DebugPrint('DeleteEntity(dealerPed):')
    DeleteEntity(dealerPed)
  end
  TriggerEvent('bm-chickenjob:SpawnDealerPed')
end

CreateThread(function()
  while true do
    while not dealerPed do
      TriggerEvent('bm-chickenjob:SpawnDealerPed')
      Wait(100)
    end
    Wait(5000)
    if dealerPed then
      local c        = GetEntityCoords(dealerPed)
      local distdiff = #(c - Config.Locations.chickenDealer.coords)
      if distdiff > 5 or GetPedSourceOfDeath(dealerPed) ~= 0 then
        DeleteAndSpawnDealer()
      end
    end
  end
end)

print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5chickenDealer^7")
