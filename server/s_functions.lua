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
