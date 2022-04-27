-- Default Command to open the battlepass.
RegisterCommand('battlepass',function(source)
    TriggerClientEvent('tp-battlepass:openBattlePass',source)
end)

-- Admin Command to Set a battlepasse xp percent on the selecter player.
ESX.RegisterCommand('setbattlepassexp', 'admin', function(xPlayer, args, showError)
    if args.playerId then

        if tonumber(args.progress) == nil then
            xPlayer.showNotification('~r~Input is invalid.')
            return
        end

        if tonumber(args.progress) < 0 or tonumber(args.progress) > 100 then
            xPlayer.showNotification('~r~Input is invalid. You cannot set a battlepass exp less than 0 or higher than 100. ')
            return
        end

        local targetSource = args.playerId.playerId
        local tPlayer = ESX.GetPlayerFromId(targetSource)

        local currentLevel = 0
        local result = MySQL.Sync.fetchAll("SELECT * FROM battlepass WHERE identifier = @identifier", {['@identifier'] = tPlayer.identifier})
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
		xPlayer.showNotification("~r~The player id is invalid")
	end
end, true, {help = "Sets battlepass exp progress on the selected player id.", validate = true, arguments = {
	{name = 'playerId', help = "Player ID", type = 'player'},
	{name = 'progress', help = "Battlepass Progress", type = 'string'}
}})