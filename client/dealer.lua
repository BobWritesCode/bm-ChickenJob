RegisterNetEvent('bm-chickenjob:AssignNewChickenDealerEnt', function(netID)
  DebugPrint2('AssignNewChickenDealerEnt: ', netID)
  Wait(200)
  AssignTargetToPed("dealer", NetworkGetEntityFromNetworkId(netID))
end)

function SellPackedChicken()
  DebugPrint2('Function called: ', 'SellPackedChicken()')
  if not QBCore.Functions.HasItem(Config.RequiredItems.packagedchicken.Name) then
    Notification(false, "You have nothing to sell!", "error", false)
    return
  end
  local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
  local prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z, true, true, true)
  SetEntityHeading(prop, GetEntityHeading(GetPlayerPed(-1)))
  exports['progressbar']:Progress({
    name = "selling_task",
    duration = Config.SellingChickenTime,
    label = "Selling chicken..",
    useWhileDead = false,
    canCancel = true,
    controlDisables = {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
    },
    animation = {
      animDict = "amb@medic@standing@tendtodead@idle_a",
      anim = "idle_a",
      flags = 1,
    },
    prop = {
    },
    propTwo = {}
  }, function(cancelled)
    DeleteEntity(prop)
    LoadDict('amb@medic@standing@tendtodead@exit')
    TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
    ClearPedTasks(GetPlayerPed(-1))
    IsPortioningChicken = false
    if not cancelled then -- finished
      TriggerServerEvent("bm-chickenjob:sell", 3)
    else                  -- cancelled
      -- pass
    end
  end)
  DebugPrint2('Function end: ', 'SellPackedChicken()')
end

print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5Dealer^7")
