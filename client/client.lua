QBCore = exports['qb-core']:GetCoreObject()

local IsPacking = false
local IsPortioningChicken = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
  StartUp()
end)

AddEventHandler('onResourceStart', function(resourceName)
  if GetCurrentResourceName() ~= resourceName then return end
  StartUp()
end)

function StartUp()
  SetUpBlips()
  if Config.UseQBTarget then
    SetUpQBTargetWorkAreas()
    GetPedEntities()
  else
    Markers1()
    Markers2()
    Markers3()
  end
end

function Markers1()
  CreateThread(function()
    while true do
      Wait(0)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1))
      local farmCoords = Config.Locations.chickenFarm.coords
      local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, farmCoords.x, farmCoords.y, farmCoords.z)
      ---
      if dist <= 20.0 then
        DrawMarker(27, farmCoords.x, farmCoords.y, farmCoords.z - 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90,
          255, 255,
          255, 200, 0, 0, 0, 0)
      else
        Wait(1500)
      end
      if dist <= 2.5 then
        DrawText3D(farmCoords.x, farmCoords.y, farmCoords.z, "~g~[E]~w~ To catch chickens")
      end
      --
      if dist <= 0.5 then
        if IsControlJustPressed(0, Config.Keys['E']) then
          TriggerServerEvent("bm-chickenjob:startChicken")
          StartChickenChase()
        end
      end
    end
  end)
end

function Markers2()
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

function Markers3()
  CreateThread(function()
    while true do
      Wait(5)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
      local dCoords = Config.Locations.chickenDealer.coords
      local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, dCoords.x, dCoords.y, dCoords.z)
      if dist <= 20.0 then
        DrawMarker(27, dCoords.x, dCoords.y, dCoords.z - 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255,
          255, 255, 200, 0, 0, 0, 0)
      else
        Wait(1000)
      end
      if dist <= 2.0 then
        DrawText3D(dCoords.x, dCoords.y, dCoords.z + 0.1, "[E] Sell packaged chicken")
        if IsControlJustPressed(0, Config.Keys['E']) then
          SellPackedChicken()
        end
      end
    end
  end)
end

print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5Client^7")
