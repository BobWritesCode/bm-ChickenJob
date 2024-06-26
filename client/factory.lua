function Packing()
  DebugPrint2('Function called: ', 'Packing()')
  if not QBCore.Functions.HasItem('slaughteredchicken') then
    Notification(false, "You have nothing to pack!", "error", false)
    return
  end
  IsPacking = true
  SetEntityHeading(GetPlayerPed(-1), 40.0)
  exports['progressbar']:Progress({
    name = "packing_task",
    duration = Config.PackagingChickenTime,
    label = "Packing..",
    useWhileDead = false,
    canCancel = true,
    controlDisables = {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
    },
    animation = {
      animDict = "anim@heists@ornate_bank@grab_cash_heels",
      anim = "grab",
      flags = 63,
    },
    prop = {
      model = 'prop_cs_steak',
      bone = 18905,
      coords = vector3(0.15, 0.0, 0.01),
      rotation = vector3(0.0, 0.0, 0.0),
    },
    propTwo = {
      model = 'prop_cs_clothes_box',
      bone = 57005,
      coords = vector3(0.13, 0.0, -0.16),
      rotation = vector3(250.0, -30.0, 0.0),
    }
  }, function(cancelled)
    IsPacking = false
    if not cancelled then
      -- finished
      TriggerServerEvent("bm-chickenjob:getpackedChicken", 2)
    else
      -- cancelled
    end
  end)
  DebugPrint2('Function end: ', 'Packing()')
end

function PortionChicken(position)
  DebugPrint2('Function called: ', 'PortionChicken()')
  IsPortioningChicken = true
  if not QBCore.Functions.HasItem(Config.RequiredItems.alivechicken.Name) then
    Notification(false, "You dont have any chickens!", "error", false)
    IsPortioningChicken = false
    return
  end
  local A, B, C, D, E
  A = Config.Locations.cutting[position].A
  B = Config.Locations.cutting[position].B
  C = Config.Locations.cutting[position].C
  D = Config.Locations.cutting[position].D
  E = Config.Locations.cutting[position].E

  SetEntityHeading(GetPlayerPed(-1), A)
  local chickenEntity = CreateObject(GetHashKey('prop_int_cf_chick_01'), B, C, D, true, true, true)
  SetEntityRotation(chickenEntity, 90.0, 0.0, E, 1, true)
  exports['progressbar']:Progress({
    name = "portion_task",
    duration = Config.CuttingUpChickenTime,
    label = "Cutting up the chicken..",
    useWhileDead = false,
    canCancel = true,
    controlDisables = {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
    },
    animation = {
      animDict = "anim@amb@business@coc@coc_unpack_cut_left@",
      anim = "coke_cut_v1_coccutter",
      flags = 63,
    },
    prop = {
      model = 'prop_knife',
      bone = 58866,
      coords = vector3(0.11, 0.03, 0.001),
      rotation = vector3(-120.0, 90.0, 225.0),
    },
    propTwo = {}
  }, function(cancelled)
    DeleteEntity(chickenEntity)
    IsPortioningChicken = false
    if not cancelled then -- finished
      Notification(false, "Now pack cut up chicken!", "primary", false)
      TriggerServerEvent("bm-chickenjob:getcutChicken", 1)
    else -- cancelled
      -- pass
    end
  end)
  DebugPrint2('Function end: ', 'PortionChicken()')
end

function FactoryMarkers()
  CreateThread(function()
    local CPCoords = Config.Locations.chickenProcessing.coords
    while true do
      Wait(5)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1))
      local distCP = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, CPCoords.x, CPCoords.y, CPCoords.z)
      while distCP > 25.0 do
        plyCoords = GetEntityCoords(GetPlayerPed(-1))
        distCP = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, CPCoords.x, CPCoords.y, CPCoords.z)
        Wait(1500)
      end
      for k, v in pairs(Config.Locations.cutting) do
        local coords = v.coords
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, coords.x, coords.y, coords.z)
        if dist <= 25.0 then
          DrawMarker(27, coords.x, coords.y, coords.z - 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255,
            255, 255, 200, 0, 0, 0, 0)
        end
        if dist <= 2.5 and not IsPortioningChicken then
          DrawText3D(coords.x, coords.y, coords.z, "~g~[E]~w~ Portion chicken")
        end
        if dist <= 0.5 and not IsPortioningChicken then
          if IsControlJustPressed(0, Config.Keys['E']) then
            PortionChicken(k)
          end
        end
      end
      for _, v in pairs(Config.Locations.packing) do
        local coords = v.coords
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, coords.x, coords.y, coords.z)
        if dist <= 25.0 then
          DrawMarker(27, coords.x, coords.y, coords.z - 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255,
            255, 255, 200, 0, 0, 0, 0)
        end
        if dist <= 2.5 and not IsPacking then
          DrawText3D(coords.x, coords.y, coords.z, "~g~[E]~w~ To pack chicken")
        end
        if dist <= 0.5 and not IsPacking then
          if IsControlJustPressed(0, Config.Keys['E']) then
            Packing()
          end
        end
      end
    end
  end)
end

print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5Factory^7")
