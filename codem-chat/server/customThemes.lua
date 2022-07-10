if Config.EnableCustomThemes then
          for _,v in pairs(Config.CustomThemes) do
              if v.useAuthorPrefix then
                  if v.enable then
                      RegisterServerEvent(v.eventName)
                      AddEventHandler(v.eventName, function(src,  playerName, message)
                          local header = v.headerSrc ~= "" and '<img src="'..v.headerSrc..'" class="ooc" />' or ""
                          local rightTop = v.rightTopCurvedSrc ~= "" and '<img src="'..v.rightTopCurvedSrc..'" class="right-top" />' or ""
                          local leftBottom = v.leftBottomCurvedSrc  ~= "" and '<img src="'..v.leftBottomCurvedSrc..'" class="left-bottom" />' or ""
                          local logo = v.logoSrc ~= "" and '<img src="'..v.logoSrc..'" class="logo" />' or ""
                          TriggerClientEvent('chat:addMessage', src, {
                              template = '<div style="position:relative; width:100%;">'..header..''..rightTop..''..leftBottom..''..logo..'<div class="chat-message " style="'..v.bgColor..'">  <div class="message" style="font-weight:600; font-size:0.938rem;">    <span style="color:'..v.authorPrefixColor..'; font-weight:700; margin-right:2px; font-size:0.938rem; ">{0} : </span>'..message:gsub('%"', '')..'  </div></div></div>',
                              args = { playerName, message:gsub('%"', '')}
                          })
                      end)
                  end
              else
                  if v.enable then
                      RegisterServerEvent(v.eventName)
                      AddEventHandler(v.eventName, function(src,   message)
                          local header = v.headerSrc and '<img src="'..v.headerSrc..'" class="ooc" />' or ""
                          local rightTop = v.rightTopCurvedSrc and '<img src="'..v.rightTopCurvedSrc..'" class="right-top" />' or ""
                          local leftBottom = v.leftBottomCurvedSrc and '<img src="'..v.leftBottomCurvedSrc..'" class="left-bottom" />' or ""
                          local logo = v.logoSrc and '<img src="'..v.logoSrc..'" class="logo" />' or ""
                          TriggerClientEvent('chat:addMessage', src, {
                              template = '<div style="position:relative; width:100%;">'..header..''..rightTop..''..leftBottom..''..logo..'<div class="chat-message " style="'..v.bgColor..'">  <div class="message" style="font-weight:600; font-size:0.938rem;">    {0}  </div></div></div>',
                              args = { message:gsub('%"', '')}
                          })
                      end)
                  end
              end
          end
end