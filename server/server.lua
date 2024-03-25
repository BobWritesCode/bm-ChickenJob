QBCore = exports['qb-core']:GetCoreObject()

local ItemList = {
  ["packagedchicken"] = math.random(50, 100),
}

----------------------------------------------------
-- Create items
----------------------------------------------------
function StartUp()
  if (Leng(Config.RequiredItems)) == 0 then return end
  for k, item in pairs(Config.RequiredItems) do
    if QBCore.Shared.Items[k] then
      print("^1[Error] ^2Tried to add item to qb shared item but already exists: ^3" .. k .. "^7")
      print(
      "^1[Error Note] ^2If you have restarted the script the item above may/would have been added at the server boot/restart.^7")
    elseif CheckItemDoesNotAlreadyExist(item.Name) then
      print("^1[Error] ^2Tried to add item to qb shared item but item name already exists: ^3" .. k .. "^7")
      print(
      "^1[Error Note] ^2If you have restarted the script the item above may/would have been added at the server boot/restart.^7")
    else
      exports['qb-core']:AddItem(
        item.Name,
        {
          name = item.Name,
          label = item.Label,
          weight = item.Weight,
          type = item.Type,
          image = item.Picture,
          unique = item.Unique,
          useable = item.useable,
          shouldClose = item.ShouldClose,
          combinable = item.Combinable,
          description = item.Description
        })
    end
  end
end

function CheckItemDoesNotAlreadyExist(itemName)
  for _, value in pairs(QBCore.Shared.Items) do
    if value.name == itemName then
      return true
    end
  end
  return false
end

function Leng(t)
  local c = 0
  for _ in pairs(t) do
    c = c + 1
  end
  return c
end

--------------------------------------------------

QBCore.Functions.CreateCallback('bm-chickenjob:GetPedEntity',
  function(_, cb, targetPed)
    DebugPrint2("Called: ", "bm-chickenjob:GetPedEntity")
    DebugPrint2("targetPed: ", targetPed)
    if targetPed == 'farmer' then
      cb(GetFarmerNetId())
      return
    elseif targetPed == 'dealer' then
      cb(GetDealerNetId())
      return
    end
    ErrorPrint('Called bm-chickenjob:GetPedEntity with an invalid arg: ', targetPed)
  end)

RegisterServerEvent('bm-chickenjob:giveChickens', function(rewardData)
  DebugPrint2("Called: ", "bm-chickenjob:giveChickens")
  GiveChickenRewards(rewardData)
end)

RegisterServerEvent('bm-chickenjob:startChicken', function()
  DebugPrint('bm-chickenjob:startChicken')
  local src = source
  Notification(src, false, "Lets catch the chicken dumbass!", "success", 8000)
end)

RegisterServerEvent('bm-chickenjob:getcutChicken', function()
  DebugPrint('bm-chickenjob:getcutChicken')
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  Notification(src, false, "Well! You slaughtered chicken.", "success", 8000)
  Player.Functions.RemoveItem(Config.RequiredItems.alivechicken.Name, 1)
  Player.Functions.AddItem(Config.RequiredItems.slaughteredchicken.Name, 1)
  TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.RequiredItems.alivechicken.Name],
    "remove")
  TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.RequiredItems.slaughteredchicken.Name],
    "add")
end)

RegisterServerEvent('bm-chickenjob:getpackedChicken', function()
  DebugPrint('bm-chickenjob:getpackedChicken')
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  Notification(src, false, "You packaged up some chicken.", "success", 8000)
  Player.Functions.RemoveItem(Config.RequiredItems.slaughteredchicken.Name, 1)
  Player.Functions.AddItem(Config.RequiredItems.packagedchicken.Name, 1)
  TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.RequiredItems.slaughteredchicken.Name],
    "remove")
  TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.RequiredItems.packagedchicken.Name],
    "add")
end)

RegisterServerEvent('bm-chickenjob:sell', function()
  DebugPrint('bm-chickenjob:sell')
  local src = source
  local price = Config.SellPrice
  local Player = QBCore.Functions.GetPlayer(src)
  if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
    for k, _ in pairs(Player.PlayerData.items) do
      if Player.PlayerData.items[k] ~= nil then
        if ItemList[Player.PlayerData.items[k].name] ~= nil then
          price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
          Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
        end
      end
    end
    Player.Functions.AddMoney("cash", price, "sold-items")
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.RequiredItems.packagedchicken.Name],
      "remove")
    Notification(src, false, "You have sold your items", "error")
  else
    Notification(src, false, "You don't have items", "error")
  end
end)

StartUp()
print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5Server^7")
