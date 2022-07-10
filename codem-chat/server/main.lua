local frameworkObject
Citizen.CreateThread(function()
    frameworkObject = Config.GetFrameWork()
end)
local function esc(x)
    return (x:gsub('%%', '%%%%')
             :gsub('^%^', '%%^')
             :gsub('%$$', '%%$')
             :gsub('%(', '%%(')
             :gsub('%)', '%%)')
             :gsub('%.', '%%.')
             :gsub('%[', '%%[')
             :gsub('%]', '%%]')
             :gsub('%*', '%%*')
             :gsub('%+', '%%+')
             :gsub('%-', '%%-')
             :gsub('%"', '%%"')
             :gsub('%""', '%%""')
             :gsub('%?', '%%?'))
 end

function GetPlayerByName(playerName)
    local Players = GetPlayers()
    if Config.Framework == "esx" then
        for _,src in pairs(Players) do
            local Player = frameworkObject.GetPlayerFromId(src)
            if Player then
                local name = Player.getName()
                if name == playerName then
                    return Player
                end
            end
       
        end
    else
        for _,src in pairs(Players) do
            local Player = frameworkObject.Functions.GetPlayer(tonumber(src))
            local name = Player.PlayerData.charinfo.firstname .. " ".. Player.PlayerData.charinfo.lastname
            if name == playerName then
                return Player
            end
        end
    end
    return false
end

 function CheckIsReply(message)
    if Config.Framework == "esx" then
        local names = {}
        local Players = GetPlayers()
        for _,src in pairs(Players) do
            local Player = frameworkObject.GetPlayerFromId(src)
            if Player then
                local name = Player.getName()
                table.insert(names, name)
            end
        end
        for _, name in pairs(names) do
          
          
            if string.find(message:lower(), esc(name:lower())) then
              
              return true, name
            end
        end
    else
        local names = {}
        local Players = GetPlayers()
        for _,src in pairs(Players) do
          
            local Player = frameworkObject.Functions.GetPlayer(tonumber(src))
            if Player then
                local name = Player.PlayerData.charinfo.firstname .. " ".. Player.PlayerData.charinfo.lastname
                table.insert(names, name)
            end
        end
        for _, name in pairs(names) do
            if string.find(message:lower(), esc(name:lower())) then
              return true, name
            end
        end
    end
    return false, false
 end

function CheckEmoji(message)
    for prefix,val in pairs(Config.Emojis) do
        if string.find(message:lower(), esc(prefix:lower())) then
            message = string.gsub(message:lower(),  esc(prefix:lower()), "<span style='transform:scale(1.5); display:inline-block; margin:0 2px' >&#x"..val.."	</span>")
        end
    end
    return message
end

function ArgsToString(prefix, rawCommand)
	local length = string.len(prefix)
	local message = rawCommand:sub(length + 1)
    if message:gsub("%s+", "") ~= "" then
        return  CheckEmoji(message)
    else
        return ""
    end
end


function GetPlayerDisplayName(source, roleplayName)
    local playerName 
    if roleplayName then
        local Player 
        if Config.Framework == "esx" then
            Player = frameworkObject.GetPlayerFromId(source)
            playerName = Player.getName()
        else
            Player = frameworkObject.Functions.GetPlayer(tonumber(source))
            playerName = Player.PlayerData.charinfo.firstname .. " ".. Player.PlayerData.charinfo.lastname
        end
    else
        playerName = GetPlayerName(source)
    end
    return playerName
end

function CheckJobs(jobs, job)
    for _,v in pairs(jobs) do
        if v == job then
            return true
        end
    end
    return false
end

function CheckPermissions(permissions, permission)
    for _,v in pairs(permissions) do
        if v == permission then
            return true
        end
    end
    return false
end

function CheckIsAdmin(source, permissions)
    if Config.Framework == "esx" then
        local Player = frameworkObject.GetPlayerFromId(source)
        if  CheckPermissions(permissions, Player.getGroup()) then
            return true
        end
    else
        
        if CheckPermissions(permissions, frameworkObject.Functions.GetPermission(source))then
            return true
        end
    end
    return false
end

function GetAdmins(permissions)
    local admins = {}
    if Config.Framework == "esx" then
        for _,v in pairs(GetPlayers()) do
            local Player = frameworkObject.GetPlayerFromId(v)
            if Player then
                if CheckPermissions(permissions, Player.getGroup()) then
                    table.insert(admins, v)
                end 
            end
        end
    else
        for _,v in pairs(GetPlayers()) do
            if CheckPermissions(permissions, frameworkObject.Functions.GetPermission(v)) then
                table.insert(admins, v)
            end 
        end
    end
    return admins
end

function CheckCanUseCommand(source, jobs)
    if Config.Framework == "esx" then
        local Player = frameworkObject.GetPlayerFromId(source)
        if Player.getJob() == nil then
            return false
        end
        if CheckJobs(jobs, Player.getJob().name) then
            return true
        end
    else
        local Player = frameworkObject.Functions.GetPlayer(tonumber(source))
        if Player.PlayerData.job == nil then
            return false
        end
        if CheckJobs(jobs, Player.PlayerData.job.name) then
            return true
        end
    end
    return CheckJobs(jobs, job)
end

function GetOnlinePlayersWithJob(jobs)
    local players = {}
    if Config.Framework == "esx" then
        for _,v in pairs(GetPlayers()) do
            local Player = frameworkObject.GetPlayerFromId(v)
            if Player then
                local playerJob = Player.getJob()
                if  CheckJobs(jobs, playerJob.name) then
                    table.insert(players, v)
                end
            end
      
        end
    else
        for _,v in pairs(GetPlayers()) do
            local Player = frameworkObject.Functions.GetPlayer(tonumber(v))
            if Player then
                local playerJob = Player.PlayerData.job.name
                if CheckJobs(jobs, playerJob) then
                    table.insert(players, v)
                end
            end
        end
    end
    return players
end

if Config.EnableCommands.enableOOC then
    RegisterCommand(Config.CommandsPrefix.ooc, function(source, args, rawCommand)
        local playerName = GetPlayerDisplayName(source, Config.UseRoleplayNames.ooc)
        local message = ArgsToString(Config.CommandsPrefix.ooc, rawCommand)
        if message ~= "" then
            for k,v in pairs(GetPlayers()) do
                
                TriggerEvent(Config.PresetChatThemes["ooc"].eventName, v, playerName, message)
            end
        end
    end)
end

if Config.EnableCommands.enableEMS then
    RegisterCommand(Config.CommandsPrefix.ems, function(source, args, rawCommand)
        local playerName = GetPlayerDisplayName(source, Config.UseRoleplayNames.ems)
        local message = ArgsToString(Config.CommandsPrefix.ems, rawCommand)
        if message ~= "" and CheckCanUseCommand(source, Config.CommandJobs.ems) then
            for _,v in pairs(GetOnlinePlayersWithJob(Config.CommandJobs.ems)) do
                TriggerEvent(Config.PresetChatThemes["ems"].eventName, v, playerName, message)
            end
        end
    end)
end

if Config.EnableCommands.enableLSPD then
    RegisterCommand(Config.CommandsPrefix.lspd, function(source, args, rawCommand)
        local playerName = GetPlayerDisplayName(source, Config.UseRoleplayNames.lspd)
        local message = ArgsToString(Config.CommandsPrefix.lspd, rawCommand)
        if message ~= "" and CheckCanUseCommand(source, Config.CommandJobs.lspd) then
            for _,v in pairs(GetOnlinePlayersWithJob(Config.CommandJobs.lspd)) do
                TriggerEvent(Config.PresetChatThemes["lspd"].eventName, v, playerName, message)
            end
        end
    end)
end

if Config.EnableCommands.enableTWT then
    RegisterCommand(Config.CommandsPrefix.twt, function(source, args, rawCommand)
        local playerName = GetPlayerDisplayName(source, Config.UseRoleplayNames.twt)
        local message = ArgsToString(Config.CommandsPrefix.twt, rawCommand)
        if message ~= "" then
            TriggerEvent(Config.PresetChatThemes["twt"].eventName, -1, playerName, message)
        end
    end)
end


    RegisterCommand("htwt", function(source, args, rawCommand)
       -- local playerName = GetPlayerDisplayName(source, Config.UseRoleplayNames.twt)
        local message = ArgsToString("htwt", rawCommand)
        if message ~= "" then
            TriggerEvent(Config.PresetChatThemes["htwt"].eventName, -1, "("..source..")ismeretlen", message)
        end
    end)


if Config.EnableCommands.enableLSCUSTOM then
    RegisterCommand(Config.CommandsPrefix.lscustom, function(source, args, rawCommand)
        local message = ArgsToString(Config.CommandsPrefix.lscustom, rawCommand)
        if message ~= "" and CheckCanUseCommand(source, Config.CommandJobs.lscustom)  then
            TriggerEvent(Config.PresetChatThemes["lscustom"].eventName, -1, message)
        end
    end)
end

if Config.EnableCommands.enableYELLOWPAGES then
    RegisterCommand(Config.CommandsPrefix.yellowpages, function(source, args, rawCommand)
        local playerName = GetPlayerDisplayName(source, Config.UseRoleplayNames.yellowpages)
        local message = ArgsToString(Config.CommandsPrefix.yellowpages, rawCommand)
        if message ~= "" then
            TriggerEvent(Config.PresetChatThemes["yellowpages"].eventName, -1, playerName, message)
        end
    end)
end

if Config.EnableCommands.enableSTAFF then
    RegisterCommand(Config.CommandsPrefix.staff, function(source, args, rawCommand)
        local playerName = GetPlayerDisplayName(source, Config.UseRoleplayNames.staff)
        local message = ArgsToString(Config.CommandsPrefix.staff, rawCommand)
        if message ~= "" and CheckIsAdmin(source, Config.StaffPermissions) then
            for _,v in pairs(GetAdmins(Config.StaffPermissions)) do
                TriggerEvent(Config.PresetChatThemes["staff"].eventName, v, playerName, message)
            end
        end
    end)
end

if Config.EnableCommands.enableADMIN then
    RegisterCommand(Config.CommandsPrefix.admin, function(source, args, rawCommand)
        local playerName = GetPlayerDisplayName(source, Config.UseRoleplayNames.admin)
        local message = ArgsToString(Config.CommandsPrefix.admin, rawCommand)
        if message ~= "" and CheckIsAdmin(source, Config.AdminPermissions) then
            for _,v in pairs(GetAdmins(Config.AdminPermissions)) do
                TriggerEvent(Config.PresetChatThemes["admin"].eventName, v, playerName, message)
            end
        end
    end)
end


if Config.EnableCommands.enableSHOP then
    RegisterCommand(Config.CommandsPrefix.shop, function(source, args, rawCommand)
        local message = ArgsToString(Config.CommandsPrefix.shop, rawCommand)
        if message ~= "" and CheckCanUseCommand(source, Config.CommandJobs.shop)  then
            TriggerEvent(Config.PresetChatThemes["shop"].eventName, -1, message)
        end
    end)
end

if Config.EnableCommands.enableCAB then
    RegisterCommand(Config.CommandsPrefix.cab, function(source, args, rawCommand)
        local playerName = GetPlayerDisplayName(source, Config.UseRoleplayNames.cab)
        local message = ArgsToString(Config.CommandsPrefix.cab, rawCommand)
        if message ~= "" and CheckCanUseCommand(source, Config.CommandJobs.cab)  then
            TriggerEvent(Config.PresetChatThemes["cab"].eventName, -1, playerName, message)
        end
    end)
end


for _,v in pairs(Config.PresetChatThemes) do
    if v.useAuthorPrefix then
        RegisterServerEvent(v.eventName)
        AddEventHandler(v.eventName, function(src,  playerName, message)
            local isReply, foundName = CheckIsReply(message:gsub('%"', ''))
            local header = v.headerSrc and '<img src="'..v.headerSrc..'" class="ooc" />' or ''
            local rightTop = v.rightTopCurvedSrc and '<img src="'..v.rightTopCurvedSrc..'" class="right-top" />' or ''
            local leftBottom = v.leftBottomCurvedSrc  and '<img src="'..v.leftBottomCurvedSrc..'" class="left-bottom" />' or ''
            local logo = v.logoSrc and '<img src="'..v.logoSrc..'" class="logo" />' or ''
            local bell = isReply and '<img class="bell" src="https://cdn.discordapp.com/attachments/950484538012864572/954463478192685166/notify.png">' or ''
            
            local bellAnn = isReply and '<div class="bell-ann"> <div class="bell-ann-wrapper"><p class="playerName">@'..foundName..'</p>'..bell..'</div>  </div>' or ''
            if _ == "cab" then
                leftBottom = v.leftBottomCurvedSrc  and '<img src="'..v.leftBottomCurvedSrc..'" class="left-bottom" />' or ''
                logo = v.logoSrc and '<img src="'..v.logoSrc..'" class="cab-logo" />' or ''
            elseif _ == "admin" then
                leftBottom = v.leftBottomCurvedSrc  and '<img src="'..v.leftBottomCurvedSrc..'" class="admin-left-bottom" />' or ''
            elseif _ == "shop" then
                logo = v.logoSrc and '<img src="'..v.logoSrc..'" class="shop-logo" />' or ''
            end
            local PlayerData 
            if foundName then
                PlayerData = GetPlayerByName(foundName)
            end
            if _ == "ooc" then
           
                bellAnn = PlayerData and bellAnn or ""
                if Config.Framework == "esx" then
                    if PlayerData then
                     
                        if tonumber(PlayerData.source) ~= tonumber(src) then
                          
                            bellAnn = ''
                        else
                            foundName = string.sub(foundName,1,5)
                           bellAnn = isReply and '<div class="bell-ann"> <div class="bell-ann-wrapper"><p class="playerName">@'..foundName..'</p>'..bell..'</div>  </div>' or ''
                          
                        end
                    end
                else
                    if PlayerData then
                        if tonumber(PlayerData.PlayerData.source) ~= tonumber(src) then
                            bellAnn = ''
                        end
                    end
                end
            else
                bellAnn = ""
            end

            
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="template-wrapper" style="position:relative; width:100%;">'..header..''..rightTop..''..leftBottom..''..logo..' '..bellAnn..'<div class="chat-message " style="'..v.bgColor..'">  <div class="message" style="font-weight:600; font-size:0.938rem;">    <span style="color:'..v.authorPrefixColor..'; font-weight:700; margin-right:2px; font-size:0.938rem; ">{0} : </span> '..message:gsub('%"', '')..'  </div></div></div>',
                args = { playerName, message}
            })
        end)
    else
       RegisterServerEvent(v.eventName)
        AddEventHandler(v.eventName, function(src,  message)
            local isReply, foundName = CheckIsReply(message:gsub('%"', ''))
            local header = v.headerSrc and '<img src="'..v.headerSrc..'" class="ooc" />' or ''
            local rightTop = v.rightTopCurvedSrc and '<img src="'..v.rightTopCurvedSrc..'" class="right-top" />' or ''
            local leftBottom = v.leftBottomCurvedSrc  and '<img src="'..v.leftBottomCurvedSrc..'" class="left-bottom" />' or ''
            local logo = v.logoSrc and '<img src="'..v.logoSrc..'" class="logo" />' or ''
            local bell = isReply and '<img class="bell" src="https://cdn.discordapp.com/attachments/950484538012864572/954463478192685166/notify.png">' or ''
            
            local bellAnn = isReply and '<div class="bell-ann"> <div class="bell-ann-wrapper"><p class="playerName">@'..foundName..'</p>'..bell..'</div>  </div>' or ''
            if _ == "cab" then
                leftBottom = v.leftBottomCurvedSrc  and '<img src="'..v.leftBottomCurvedSrc..'" class="left-bottom" />' or ''
                logo = v.logoSrc and '<img src="'..v.logoSrc..'" class="cab-logo" />' or ''
            elseif _ == "admin" then
                leftBottom = v.leftBottomCurvedSrc  and '<img src="'..v.leftBottomCurvedSrc..'" class="admin-left-bottom" />' or ''
            elseif _ == "shop" then
                logo = v.logoSrc and '<img src="'..v.logoSrc..'" class="shop-logo" />' or ''
            end
            local PlayerData 
            if foundName then
                PlayerData = GetPlayerByName(foundName)
            end
            if _ == "ooc" then
           
                bellAnn = PlayerData and bellAnn or ""
                if Config.Framework == "esx" then
                    if PlayerData then
                     
                        if tonumber(PlayerData.source) ~= tonumber(src) then
                          
                            bellAnn = ''
                        else
                            foundName = string.sub(foundName,1,5)
                           bellAnn = isReply and '<div class="bell-ann"> <div class="bell-ann-wrapper"><p class="playerName">@'..foundName..'</p>'..bell..'</div>  </div>' or ''
                          
                        end
                    end
                else
                    if PlayerData then
                        if tonumber(PlayerData.PlayerData.source) ~= tonumber(src) then
                            bellAnn = ''
                        end
                    end
                end
            else
                bellAnn = ""
            end
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div  class="template-wrapper" style="position:relative; width:100%;">'..header..''..rightTop..''..leftBottom..''..logo..'<div class="chat-message " style="'..v.bgColor..'">  <div class="message" style="font-weight:600; font-size:0.938rem;">    '..message:gsub('%"', '')..'  </div></div></div>',
                args = { message:gsub('%"', '')}
            })
        end)
    end
end



RegisterServerEvent("codem-chat:SyncToEveryone")
AddEventHandler("codem-chat:SyncToEveryone", function(toggle)
    if Config.EnableDotOverHead then
        local src = source
        TriggerClientEvent('codem-chat:Sync', -1, src, toggle)
    end
end)