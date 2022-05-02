ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Default Command to open the battlepass.
RegisterCommand('battlepass',function(source)
    TriggerClientEvent('tp-battlepass:openBattlePass',source)
end)

-- Admin Command to Set a battlepasse xp percent on the selecter player.
TriggerEvent('es:addGroupCommand', 'setbattlepassexp', 'admin', function(source, args, user)
	if tonumber(args[1]) and tonumber(args[2]) then

		local xPlayer = ESX.GetPlayerFromId(args[1])

		if xPlayer then

            local progress = tonumber(args[2])

            if progress < 0 or progress > 100 then
                TriggerClientEvent('chat:addMessage', source, { args = { '~r~Input is invalid. You cannot set a battlepass exp less than 0 or higher than 100. '} })
                return
            end

            local currentLevel = 0
            
            local result = MySQL.Sync.fetchAll("SELECT * FROM battlepass WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
            if result[1] then 
                local playerStats = result[1]
        
                currentLevel = playerStats['level']
            else
                currentLevel = 1
            end
    
            local maxPercent = Config.LevelsConfiguration[tonumber(currentLevel)].playedTimeRequired
    
            local percentResult = maxPercent / 100 * tonumber(args.progress)
    
            xPlayer.showNotification('~g~Successfully set ' .. args.playerId.name .. " Battlepass Progress to: " .. args.progress .. "%")
    
            playerData[targetSource] = math.floor(percentResult)
            SavePlayerBattlepassData(targetSource)


		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1', 'The player id is invalid or offline.' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1', 'Invalid usage.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1', 'Not enough permissions to perform this action.' } })
end, {help = "Sets battlepass exp progress on the selected player id.", params = {{name = "playerId", help = "playerId"}, {name = "progress", help = "progress"}}})
