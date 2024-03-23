function Notification(src, _title, msg, _notifyType, _notifyTime)
  if Config.Notify == "QB" then
    local notifyTime = _notifyTime or 5000
    local notifyType = _notifyType or "primary"
    TriggerClientEvent('QBCore:Notify', src, msg, notifyType, notifyTime)
  elseif Config.Notify == "okokNotify" then
    local title = _title or "Chicken Job"
    local notifyTime = _notifyTime or 5000
    local notifyType = _notifyType or "primary"
    TriggerClientEvent('okokNotify:Alert', src, title, msg, notifyTime, notifyType)
  end
end

function GiveChickenRewards(rewardData)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  DebugPrint("Giving reward items")
  for k, v in pairs(rewardData) do
    if not QBCore.Shared.Items[k] then
      ErrorPrint("Item does not exist: ", k)
    else
      DebugPrint2("Item: ", k)
      DebugPrint2("Label: ", v.label)
      DebugPrint2("amount: ", v.amount)
      local label = v.label
      local amount = v.amount
      Notification(src, "Chicken Chase Rewards", "You received " .. amount .. " " .. label .. "(s)!", "success", 8000)
      Player.Functions.AddItem(k, amount)
      TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[k], "add")
    end
  end
end

function ErrorPrint(str1, str2)
  print("^1[Error] ^2" .. tostring(str1) .. "^3" .. tostring(str2) .. "^7")
end

function DebugPrint(str)
  if Config.Debug then print("^4[Debug] ^2" .. tostring(str) .. "^7") end
end

function DebugPrint2(str1, str2)
  if Config.Debug then print("^4[Debug] ^2" .. tostring(str1) .. "^3" .. tostring(str2) .. "^7") end
end
