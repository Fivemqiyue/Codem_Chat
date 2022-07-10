local dot = ""
local players = {}




local updateData = {

}
RegisterNetEvent("codem-chat:Sync")
AddEventHandler("codem-chat:Sync", function(source, toggle)
  source = tonumber(source)
  local sonid = GetPlayerFromServerId(source)
  local monid = PlayerId()
  if sonid == -1 then
    return
  end
  if toggle then
    players[source] = {shouldOpen = toggle, monId = monid, sonId = sonid, inDist = false, dot = 0, lastUpdate = nil, lastUpdate2 = nil} 
  else
    players[source] = nil 
  end
  if players[source] == nil then
      updateData[sonid] = nil
      SendNUIMessage({
        type = "remove",
        sonid = sonid,
      })
  end

end)

local checkAlready = false


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(750)
    for k , v in pairs(players) do
      if v then
          v.dot = v.dot + 1
          if v.dot > 3 then
            v.dot = 0
          end
      end
    end
  end
end)

local defaultScale = 0.8 -- Text scale

function DrawText3d(coords, text, color)
  
  local camCoords = GetGameplayCamCoord()


    local dist = #(coords - camCoords)

  -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

  --if onScreen then

      -- Format the text
      SetTextColour(color.r,color.g, color.b, 255)
      SetTextFont(fontId)
      SetTextScale(0.0, defaultScale * scale)
      SetTextDropshadow(0, 0, 0, 0, 55)
      SetTextDropShadow()
      SetTextCentre(true)

      -- Diplay the text
      BeginTextCommandDisplayText("STRING")
      AddTextComponentSubstringPlayerName(text)
      SetDrawOrigin(coords, 0)
      EndTextCommandDisplayText(0.0, 0.0)
      ClearDrawOrigin()
  --end
  end

Citizen.CreateThread(function()
  if Config.EnableDotOverHead then
    while true do
      Citizen.Wait(0)
      local html = ""
      local update = false
      for k, v in pairs(players) do
        if v then
          local target = GetPlayerPed(v.sonId)
          local targetCoords = GetEntityCoords(target)
          local coords = GetPedBoneCoords(target, 0x796E, 0.37, 0.0, 0.03)
       
          if v.dot == 1 then
            DrawText3d(coords,".", {r = 247, g = 26, b = 112})
          end
  
          if v.dot == 2 then
            DrawText3d(coords,"..", {r = 19, g = 255, b = 237})
          end
          if v.dot == 3 then
            DrawText3d(coords,"...", {r = 255, g = 140, b = 0})
  
          end
        end
      end
    end
  end
end)

RegisterNetEvent("codem-chat:OnChatOpen")
AddEventHandler("codem-chat:OnChatOpen", function()
    if Config.EnableDotOverHead then
        dot = ""
        TriggerServerEvent('codem-chat:SyncToEveryone', true)
    end
end)

RegisterNetEvent("codem-chat:OnChatClose")
AddEventHandler("codem-chat:OnChatClose", function()
    if Config.EnableDotOverHead then
        dot = ""
        TriggerServerEvent('codem-chat:SyncToEveryone', false)
    end
end)
