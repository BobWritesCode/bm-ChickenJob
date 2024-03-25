local farmerEnt
local dealerEnt

CreateThread(function()
  while true do
    Wait(1000)
    local pCoords = GetEntityCoords(PlayerPedId())
    DebugPrint2('Dist to farmer: ', #(pCoords - Config.Locations.chickenFarm.coords) )
    DebugPrint2('farmerEnt: ',farmerEnt )
    if (#(pCoords - Config.Locations.chickenFarm.coords) < 20 and (farmerEnt == nil or farmerEnt == 0)) then
      GetPedEntity('farmer')
    end
    if (#(pCoords - Config.Locations.chickenDealer.coords) < 20 and dealerEnt == nil) then
      GetPedEntity('dealer')
    end
  end
end)

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

-- Arg: Accepted values are 'dealer' or 'farmer'.
function GetPedEntity(targetPed)
  DebugPrint2('Function: ', 'GetPedEntity')
  DebugPrint2('targetPed: ', 'targetPed')
  QBCore.Functions.TriggerCallback('bm-chickenjob:GetPedEntity', function(NetID)
    DebugPrint('bm-chickenjob:GetPedEntity')
    Wait(200)
    AssignTargetToPed(targetPed, NetworkGetEntityFromNetworkId(NetID))
  end, targetPed)
end

function AssignTargetToPed(targetPed, ent)
  DebugPrint2('Function: ', 'AssignTargetToPed()')
  DebugPrint2('target: ', targetPed)
  DebugPrint2('ent :', ent)
  local label
  local targetFunction
  if targetPed == "farmer" then
    if farmerEnt then
      exports['qb-target']:RemoveTargetEntity(farmerEnt, 'Remove farmer Ent')
    end
    farmerEnt = ent
    label = 'Catch some chickens'
    targetFunction = function() StartChickenChase() end
  elseif targetPed == "dealer" then
    if dealerEnt then
      exports['qb-target']:RemoveTargetEntity(dealerEnt, 'Remove dealer Ent')
    end
    dealerEnt = ent
    label = 'Sell packaged chickens.'
    targetFunction = function() SellPackedChicken() end
  else
    ErrorPrint('Called AssignTargetToPed with an invalid arg: ',targetPed)
    return
  end
  exports['qb-target']:AddTargetEntity(ent, {
    options = {
      {
        icon = 'fas fa-example',
        label = label,
        targeticon = 'fas fa-example',
        action = targetFunction,
      }
    },
    distance = 2.5,
  })
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

print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5Client Functions^7")
