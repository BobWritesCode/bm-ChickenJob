local IsPlayerCatchingChickens = false
local Chickens = {
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

RegisterNetEvent('bm-chickenjob:AssignNewChickenFarmerEnt', function(netID)
  DebugPrint2('AssignNewChickenFarmerEnt: ', netID)
  Wait(200)
  AssignTargetToPed("farmer", NetworkGetEntityFromNetworkId(netID))
end)

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
  if IsPlayerCatchingChickens then
    Notification(false, "You are already doing this activity", "error", 8000)
    return
  end
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

function WorkOutChickenChaseReward(NumberOfCaughtChickens)
  DebugPrint2("Function: ", 'WorkOutChickenChaseReward()')
  local rewardData = {}
  local i = 0
  while i < NumberOfCaughtChickens do
    DebugPrint2("Iteration: ", i + 1)
    for k, v in pairs(Config.ChickenCaptureRewards) do
      DebugPrint2("Item: ", k)
      local chance = math.random(1, 100)
      DebugPrint2("Chance: ", chance)
      if chance <= v.chance then
        DebugPrint2("Got a ", v.label)
        if not rewardData[k] then
          DebugPrint2("Assigning item to reward table: ", k)
          rewardData[k] = {}
          rewardData[k].label = v.label
          rewardData[k].amount = 1
        else
          DebugPrint2("Adding additonal amount to: ", k)
          rewardData[k].amount = rewardData[k].amount + 1
        end
      end
    end
    i = i + 1
  end
  DebugPrint2("rewardData: ", rewardData)
  return rewardData
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
        local rewardData = WorkOutChickenChaseReward(NumberOfCaughtChickens)
        TriggerServerEvent("bm-chickenjob:giveChickens", rewardData)
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

print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5Farm^7")
