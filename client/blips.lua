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

print("^1[Bob\'s Mods] ^2Chicken Job ^7- ^5Blips^7")
