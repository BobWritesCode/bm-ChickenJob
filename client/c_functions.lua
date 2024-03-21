IsPlayerCatchingChickens = false
IsPortioningChicken = false
IsPacking = false
Chickens = {
  chicken1 = {
    entity = nil,
    coords = vector3(0, 0, 0),
    dist = nil,
    isCaught = false,
  },
  chicken2 = {
    entity = nil,
    coords = vector3(0, 0, 0),
    dist = nil,
    isCaught = false,
  },
  chicken3 = {
    entity = nil,
    coords = vector3(0, 0, 0),
    dist = nil,
    isCaught = false,
  }
}

function SetUpBlips()
  local blips = {}
  for index, location in pairs(Config.Locations) do
    if location.blipName then
      blips[index] = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
      SetBlipSprite(blips[index], location.blipSprite)
      SetBlipDisplay(blips[index], location.blipDisplay)
      SetBlipScale(blips[index], location.blipScale)
      SetBlipColour(blips[index], location.blipColour)
      SetBlipAsShortRange(blips[index], true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(location.blipName)
      EndTextCommandSetBlipName(blips[index])
    end
  end
end

DrawText3D = function(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x, y, z, 0)
  DrawText(0.0, 0.0)
  local factor = (string.len(text)) / 370
  DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
  ClearDrawOrigin()
end

function LoadDict(dict)
  DebugPrint2('Function called: ', 'LoadDict()')
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
    Wait(10)
  end
end

function DiveForChicken()
  DebugPrint2('Function called: ', 'DiveForChicken()')
  LoadDict('move_jump')
  TaskPlayAnim(GetPlayerPed(-1), 'move_jump', 'dive_start_run', 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
  Wait(600)
  SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
  Wait(1000)
  local ChanceOfCapture = math.random(1, 100)
  if ChanceOfCapture <= Config.CaptureChance then
    Notification(false, "You managed to catch a chicken!", "success", false)
    return true
  else
    Notification(false, "The chicken escaped your arms!", "error", false)
    return false
  end
end

function StartChickenChase()
  DebugPrint2('Function called: ', 'StartChickenChase()')
  DoScreenFadeOut(500)
  Wait(500)
  SetEntityCoordsNoOffset(GetPlayerPed(-1), 2385.963, 5047.333, 46.400, 0, 0, 1)
  RequestModel(GetHashKey('a_c_hen'))
  while not HasModelLoaded(GetHashKey('a_c_hen')) do
    Wait(1)
  end
  DebugPrint('Creating chicken peds')
  Chickens.chicken1.entity = CreatePed(26, "a_c_hen", 2370.262, 5052.913, 46.437, 276.351, true, false)
  Chickens.chicken1.isCaught = false
  DebugPrint2('Chicken 1: ', Chickens.chicken1.entity)
  Chickens.chicken2.entity = CreatePed(26, "a_c_hen", 2372.040, 5059.604, 46.444, 223.595, true, false)
  Chickens.chicken2.isCaught = false
  DebugPrint2('Chicken 2: ', Chickens.chicken2.entity)
  Chickens.chicken3.entity = CreatePed(26, "a_c_hen", 2379.192, 5062.992, 46.444, 195.477, true, false)
  Chickens.chicken3.isCaught = false
  DebugPrint2('Chicken 3: ', Chickens.chicken3.entity)
  DebugPrint('Chicken peds should have been created.')
  DebugPrint('Tasking chickens to flee.')
  for i, chicken in pairs(Chickens) do
    DebugPrint2('Chicken ' .. i .. ': ', chicken.entity)
    while not DoesEntityExist(chicken.entity) do
      Wait(5)
    end
    TaskReactAndFleePed(chicken.entity, GetPlayerPed(-1))
  end
  DebugPrint('Chickens should be fleeing.')
  Wait(500)
  DoScreenFadeIn(500)
  IsPlayerCatchingChickens = true
  ChickenChaseThread()
  DebugPrint2('Function end: ', 'StartChickenChase()')
end

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

function ChickenChaseThread()
  CreateThread(function()
    local NumberOfCaughtChickens = 0
    while IsPlayerCatchingChickens do
      Wait(5)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1))
      local farm = Config.Locations.chickenFarm.coords
      if Vdist(plyCoords.x, plyCoords.y, plyCoords.z, farm.x, farm.y, farm.z) > 40 then
        EndChickenChase()
      end
      for _, chicken in pairs(Chickens) do
        local cCoords = GetEntityCoords(chicken.entity)
        local Vdist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, cCoords.x, cCoords.y, cCoords.z)
        if Vdist <= 3.0 then
          DrawText3D(cCoords.x, cCoords.y, cCoords.z + 0.5, "~o~[E]")
          if IsControlJustPressed(0, Config.Keys['E']) then
            local isCaught = DiveForChicken()
            if isCaught then
              chicken.isCaught = isCaught
              DeleteEntity(chicken.entity)
              NumberOfCaughtChickens = NumberOfCaughtChickens + 1
            end
          end
        end
      end
      if NumberOfCaughtChickens == 3 then
        IsPlayerCatchingChickens = false
        Notification(false, "Take the chickens to the processing factory ..", "primary", 8000)
        TriggerServerEvent("bm-chickenjob:giveChickens")
      end
    end
  end)
end

function EndChickenChase()
  Notification(false, "Chicken chase has ended", "error", 5000)
  IsPlayerCatchingChickens = false
  for _, chicken in pairs(Chickens) do
    DeleteEntity(chicken.entity)
  end
end

-- [QB-Target required] Spawns farmer ped
function SpawnFarmer()
  CreateThread(function()
    local model = Config.Locations.chickenFarm.PedModel
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(0)
    end
    local coords = Config.Locations.chickenFarm.coords
    local h = Config.Locations.chickenFarm.PedModelHeading
    local entity = CreatePed(0, model, coords, h, true, false)
    exports['qb-target']:AddTargetEntity(entity, {
      options = {
        {
          icon = 'fas fa-example',
          label = 'Catch some chickens',
          targeticon = 'fas fa-example',
          action = function(_entity)
            if IsPedAPlayer(_entity) then return false end
            if CheckCorrectLocation(coords) then SellPackedChicken() end
          end,
        }
      },
      distance = 2.5,
    })
  end)
end

-- [QB-Target required] Spawns chicken dealer ped
function SpawnDealer()
  CreateThread(function()
    local model = Config.Locations.chickenDealer.PedModel
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(0)
    end
    local coords = Config.Locations.chickenDealer.coords
    local h = Config.Locations.chickenDealer.PedModelHeading
    local entity = CreatePed(0, model, coords, h, true, false)
    exports['qb-target']:AddTargetEntity(entity, {
      options = {
        {
          icon = 'fas fa-example',
          label = 'Sell packaged chickens.',
          targeticon = 'fas fa-example',
          action = function(_entity)
            if IsPedAPlayer(_entity) then return false end
            if CheckCorrectLocation(coords) then SellPackedChicken() end
          end,
        }
      },
      distance = 2.5,
    })
  end)
end

function SetUpQBTargetWorkAreas()
  local x = 1
  for k, v in pairs(Config.Locations.cutting) do
    if Config.Debug then print("^4[Debug] ^2Setting up workarea at: ^3" .. v.QBTargetCoords .. "^7") end
    exports['qb-target']:AddCircleZone("workarea_" .. tostring(x), vector3(v.QBTargetCoords), 0.7, {
      name = "workarea_" .. tostring(x),
      useZ = true,
      debugPoly = Config.Debug,
    }, {
      options = {
        {
          type = 'client',
          action = function()
            PortionChicken(k)
          end,
          icon = 'fas fa-sign-in-alt',
          label = 'Prepare chicken',
        },
      },
      distance = 1.5
    })
    x = x + 1
  end
  for k, v in pairs(Config.Locations.packing) do
    if Config.Debug then print("^4[Debug] ^2Setting up workarea at: ^3" .. v.QBTargetCoords .. "^7") end
    exports['qb-target']:AddCircleZone("workarea_" .. tostring(x), vector3(v.QBTargetCoords), 0.7, {
      name = "workarea_" .. tostring(x),
      useZ = true,
      debugPoly = Config.Debug,
    }, {
      options = {
        {
          type = 'client',
          action = function()
            Packing()
          end,
          icon = 'fas fa-sign-in-alt',
          label = 'Package chicken',
        },
      },
      distance = 1.5
    })
    x = x + 1
  end
end

function CheckCorrectLocation(_coords)
  local plyCoords = GetEntityCoords(GetPlayerPed(-1))
  local coords = _coords
  if Vdist(plyCoords, coords) < 5 then
    return true
  end
  Notification(false, "Too far from required location", "error", 5000)
  return false
end

function Notification(_title, _msg, _notifyType, _notifyTime)
  DebugPrint2('Function called: ', 'Notification()')
  if Config.Notify == "QB" then
    local notifyTime = _notifyTime or 5000
    local notifyType = _notifyType or "primary"
    QBCore.Functions.Notify(_msg, notifyType, notifyTime)
  elseif Config.Notify == "okokNotify" then
    local title = _title or "Chicken Job"
    local notifyTime = _notifyTime or 5000
    local notifyType = _notifyType or "primary"
    exports['okokNotify']:Alert(title, _msg, notifyTime, notifyType)
  end
end

function DebugPrint(str)
  if Config.Debug then print("^4[Debug] ^2" .. tostring(str) .. "^7") end
end

function DebugPrint2(str1, str2)
  if Config.Debug then print("^4[Debug] ^2" .. tostring(str1) .. "^3" .. tostring(str2) .. "^7") end
end
