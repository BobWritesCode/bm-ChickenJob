QBCore = exports['qb-core']:GetCoreObject()

-- Create iteams
for _, item in pairs(Config.RequiredItems) do
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

local ItemList = {
  ["packagedchicken"] = math.random(50, 100),
}

RegisterServerEvent('bm-chickenjob:giveChickens', function()
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  Notification(src, false, "You received 3 alive chickens!", "success", 8000)
  Player.Functions.AddItem(Config.RequiredItems.alivechicken.Name, 3)
  TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.RequiredItems.alivechicken.Name], "add")
end)

RegisterServerEvent('bm-chickenjob:startChicken', function()
  local src = source
  Notification(src, false, "Lets catch the chicken dumbass!", "success", 8000)
end)

RegisterServerEvent('bm-chickenjob:getcutChicken', function()
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


print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5Started.^7")
