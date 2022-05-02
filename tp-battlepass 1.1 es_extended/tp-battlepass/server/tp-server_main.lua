ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

playerData = {}

-- Save player data / progress when the player leaves or disconnects from the game.
AddEventHandler('playerDropped', function(reason)
    SavePlayerBattlepassData(source)
end)

-- Save all players data / progress when the resource stops.
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    for k,v in pairs(ESX.GetPlayers()) do

        if v and playerData[v] then
            playerData[v] = playerData[v] + 1 
            SavePlayerBattlepassData(v)
        end
    end

    print("Saved all online players battlepass data / progress.")
end)


-- Updating online players battlepass progress every minute.
CreateThread(function()
    while true do
        Citizen.Wait(60000)

        for k,v in pairs(ESX.GetPlayers()) do

            if v and playerData[v] then
                playerData[v] = playerData[v] + 1 
                --SavePlayerBattlepassData(v)
            end
        end
    end
end)

-- Load player information data when joining the server.
RegisterServerEvent("tp-battlepass:loadPlayerInformation")
AddEventHandler("tp-battlepass:loadPlayerInformation", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * from battlepass WHERE identifier = @identifier',{
            ["@identifier"] = xPlayer.identifier
        },function (info)
            if info[1] == nil then
                MySQL.Async.execute('INSERT INTO battlepass (identifier, name, playtime, level) VALUES (@identifier, @name, @playtime, @level)',
                {
                    ['@identifier'] = xPlayer.identifier,
                    ['@name'] = GetPlayerName(source),
                    ['@playtime'] = 0,
                    ['@level']   = 1
                })
                playerData[source] = 0
            else
                playerData[source] = info[1].playtime
            end
        end)
    end
end)

-- Buy Level Boost to unlock more rewards.
RegisterServerEvent("tp-battlepass:buyLevel")
AddEventHandler("tp-battlepass:buyLevel", function (currentLevel, selectedLevel, cost)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then

        if playerData[source] == Config.LevelsConfiguration[tonumber(selectedLevel)].playedTimeRequired then 
            print("has full level, please receive level reward first before purchasing levels")
            return
        end

        xPlayer.removeMoney(cost)

        playerData[source] = 0

        MySQL.Sync.execute('UPDATE battlepass SET playtime = @playtime, level = @level WHERE identifier = @identifier', {
            ["identifier"] = xPlayer.identifier,
            ["playtime"] = 0,
            ["level"] = selectedLevel  +1
        }) 

        for i=currentLevel,selectedLevel do 
            
            local claimedLevel = Config.LevelsConfiguration[tonumber(i)].levelReward

            local type, givenReward, givenAmount = claimedLevel.type, claimedLevel.reward, claimedLevel.amount
        
            if type  == 'item' then
                xPlayer.addInventoryItem(givenReward, givenAmount)
        
            elseif type  == 'weapon' then
                xPlayer.addWeapon(givenReward, givenAmount)
        
            elseif type == 'money' then
                xPlayer.addMoney(givenAmount)
        
            elseif type == 'black_money' then
                xPlayer.addAccountMoney('black_money', givenAmount)
        
            elseif type == 'bank' then
                xPlayer.addAccountMoney('bank', givenAmount)
    
            else

                if Config.levelRewardPacks[type] then
                    local rewards = Config.levelRewardPacks[type].rewards

                    for k, v in pairs(rewards) do

                        if v.type  == 'item' then
                            xPlayer.addInventoryItem(v.name, v.amount)
                    
                        elseif v.type  == 'weapon' then
                            xPlayer.addWeapon(v.name, 0)
                    
                        elseif v.type == 'money' then
                            xPlayer.addMoney(v.amount)
                    
                        elseif v.type == 'black_money' then
                            xPlayer.addAccountMoney('black_money', v.amount)
                    
                        elseif v.type == 'bank' then
                            xPlayer.addAccountMoney('bank', v.amount)
                        end
                    end
                else
                    print("Tried to buy a non existing levelReward Type. Make sure {"..type.."} exists in Config.levelRewardPacks.")
                end
            end

        end

        TriggerClientEvent('tp-battlepass:openBattlePass',source)

        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U("rewards_claimed")})
    end

end)

RegisterServerEvent("tp-battlepass:claimReward")
AddEventHandler("tp-battlepass:claimReward", function (level)

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then

        local level = tonumber(level)
        local selectedLevel = Config.LevelsConfiguration[level].levelReward

        local type, givenReward, givenAmount = selectedLevel.type, selectedLevel.reward, selectedLevel.amount
        
        playerData[xPlayer.source] = 0

        MySQL.Sync.execute('UPDATE battlepass SET playtime = @playtime, level = @level WHERE identifier = @identifier', {
            ["identifier"] = xPlayer.identifier,
            ["playtime"] = 0 ,
            ["level"] = level + 1
        }) 
    
        print(level, selectedLevel, type, givenReward, givenAmount)
        if type  == 'item' then
            xPlayer.addInventoryItem(givenReward, givenAmount)
    
        elseif type  == 'weapon' then
            xPlayer.addWeapon(givenReward, givenAmount)
    
        elseif type == 'money' then
            xPlayer.addMoney(givenAmount)
    
        elseif type == 'black_money' then
            xPlayer.addAccountMoney('black_money', givenAmount)
    
        elseif type == 'bank' then
            xPlayer.addAccountMoney('bank', givenAmount)

        else

            if Config.levelRewardPacks[type] then
                local rewards = Config.levelRewardPacks[type].rewards

                for k, v in pairs(rewards) do

                    if v.type  == 'item' then
                        xPlayer.addInventoryItem(v.name, v.amount)
                
                    elseif v.type  == 'weapon' then
                        xPlayer.addWeapon(v.name, 0)
                
                    elseif v.type == 'money' then
                        xPlayer.addMoney(v.amount)
                
                    elseif v.type == 'black_money' then
                        xPlayer.addAccountMoney('black_money', v.amount)
                
                    elseif v.type == 'bank' then
                        xPlayer.addAccountMoney('bank', v.amount)
                    end
                end
            else
                print("Tried to buy a non existing levelReward Type. Make sure {"..type.."} exists in Config.levelRewardPacks.")
            end
        end
    
        TriggerClientEvent('tp-battlepass:openBattlePass', xPlayer.source)
    
        TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = _U("rewards_claimed_for_level") .. level})
    end

end)


ESX.RegisterServerCallback('tp-battlepass:getPlayerBattlepassInfo', function(source,cb)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)


    if xPlayer then

        MySQL.Async.fetchAll('SELECT * from battlepass WHERE identifier = @identifier',
        {
            ["@identifier"] = xPlayer.identifier

        },function (playerStatus)
    
            if playerStatus[1] then

                local currentLevel = playerStatus[1].level 
                local playtime = playerData[source]

                if Config.LevelsConfiguration[currentLevel] == nil then
                    local playerInfo = {
                        level              = currentLevel - 1,
                        percentage         = 100,
                        playedTime         = 0,
                        remainingTime      = 0,
                        requiredTime       = 0,
                        money              = xPlayer.getMoney(),
                        canClaim           = false,
                        hasBattlepassEnded = true
                    }
    
                    cb(playerInfo)
                else

                    local target = Config.LevelsConfiguration[currentLevel].playedTimeRequired

  
                    local progress = math.floor( (playtime/target) * 100 )
    
                    local canClaim = canClaim(playtime,target)
                    local remainingProgress = target-playtime
        
                    if canClaim then
                        progress, remainingProgress = 100, 0
                    end
        
                    local playerInfo = {
                        level              = currentLevel,
                        percentage         = progress,
                        playedTime         = playtime,
                        remainingTime      = remainingProgress,
                        requiredTime       = Config.LevelsConfiguration[currentLevel].playedTimeRequired,
                        money              = xPlayer.getMoney(),
                        canClaim           = canClaim,
                        hasBattlepassEnded = false
                    }
    
                    cb(playerInfo)
                end
    
            end
    
        end)
    end

end)

ESX.RegisterServerCallback("tp-battlepass:fetchUserBattlepassLevel", function(source, cb)
    local _source = source

    local xPlayer = ESX.GetPlayerFromId(source)
	
    local result = MySQL.Sync.fetchAll("SELECT * FROM battlepass WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
    if result[1] then 
        local playerStats = result[1]

        return {
            cb(playerStats['level'])
        }
    else
        return cb(1)
    end
end)

ESX.RegisterServerCallback("tp-battlepass:canBuyLevel", function(source, cb, cost)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local currentMoney = xPlayer.getMoney()

        if cost <= currentMoney then
            cb(true)
        else
            cb(false)
        end
	else
		cb(false)
	end
end)

function canClaim(playtime,target)
    if tonumber(playtime) >= tonumber(target) then
        return true
    else
        return false
    end
end


function SavePlayerBattlepassData(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then

        MySQL.Sync.execute('UPDATE battlepass SET playtime = @playtime WHERE identifier = @identifier', {
            ["identifier"] = xPlayer.identifier,
            ["playtime"] = playerData[source]
        }) 

    end
end
