local isAllowedToClose = false

local guiEnabled, isDead = false, false
local myIdentity = {}

local uiType = 'enable_battlepass'

cachedData = {}

if ESX.IsPlayerLoaded() then
	Citizen.SetTimeout(100, function()
		ESX.PlayerLoaded = true
		ESX.PlayerData = ESX.GetPlayerData()

		Wait(1000)

		SendNUIMessage({
			action = 'mainData',
			battlepass_levels = #Config.LevelsConfiguration
		})	

	
		TriggerServerEvent('tp-battlepass:loadPlayerInformation')
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData, isNew)
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData

	Wait(1000)

	SendNUIMessage({
		action = 'mainData',
		battlepass_levels = #Config.LevelsConfiguration
	})	

	TriggerServerEvent('tp-battlepass:loadPlayerInformation')
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		SetNuiFocus(false,false)
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true

	if guiEnabled then
		EnableGui(false, uiType)
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

function EnableGui(state, ui)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = ui,
		enable = state
	})
end

RegisterNUICallback('closeNUI', function()
	EnableGui(false, uiType)
end)

function closeBaseUI()
	EnableGui(false, uiType)
end


RegisterNetEvent("tp-battlepass:closeBaseUI")
AddEventHandler("tp-battlepass:closeBaseUI", function()
	EnableGui(false, uiType)
end)


RegisterNetEvent('tp-battlepass:openBattlePass')
AddEventHandler('tp-battlepass:openBattlePass', function()

	if not isDead then
		local levelCost = 0


		ESX.TriggerServerCallback('tp-battlepass:getPlayerBattlepassInfo', function(cb) 
			uiType = "enable_loading"

			EnableGui(true, uiType)

			Wait(200)


			for k,v in pairs(Config.LevelsConfiguration) do

	
				if cb.canClaim and v.level == cb.level then
					SendNUIMessage({
						action = 'addLevels',
						level_detail = v.levelReward,
						status = 'canClaim'
					})
				elseif (v.level < cb.level) or cb.hasBattlepassEnded then
					SendNUIMessage({
						action = 'addLevels',
						level_detail = v.levelReward,
						status = 'claimed'
					})					
				elseif v.level == cb.level then
					levelCost = levelCost + Config.LevelUpCost
					SendNUIMessage({
						action = 'addLevels',
						level_detail = v.levelReward,
						status = 'loading',
						cost   = levelCost
					})
				else
					levelCost = levelCost + Config.LevelUpCost
	
					SendNUIMessage({
						action = 'addLevels',
						level_detail = v.levelReward,
						status = 'waiting',
						cost   = levelCost
					})
				end
			end
	
	
			SendNUIMessage({
				action = 'addPlayerDetails',
				level = cb.level,
				percentage = cb.percentage,
				playedTime    = cb.playedTime,
				remainingTime = cb.remainingTime,
				requiredTime  = cb.requiredTime,
				dc            = cb.money,
				levelCost     = Config.LevelUpCost
			})
			
			uiType = "enable_battlepass"
			
			EnableGui(true, uiType)

		end)
			 
	end
end)

RegisterNUICallback('claimRewards', function (data)
	TriggerServerEvent('tp-battlepass:claimReward',data.level)
end)

RegisterNUICallback('buyLevel', function (data)

	local paidLevels   = math.floor(data.level - data.currentLevel)
	local levelCost    = (Config.LevelUpCost * paidLevels) + Config.LevelUpCost

	ESX.TriggerServerCallback('tp-battlepass:canBuyLevel', function(cb)

		if cb then
			TriggerServerEvent("tp-battlepass:buyLevel", data.currentLevel, data.level, levelCost)

		else
			TriggerEvent('mythic_notify:client:SendAlert',  { type = 'error', text = 'You dont have enough Donate Coins (' .. levelCost .. ') to perform this action.', style = { ['background-color'] = '#DC143C', ['color'] = '#FFFFFF' } })
		end

	end, levelCost)

end)

RegisterNUICallback('displayReceivedReward', function (data)

	SendNUIMessage({
		action = 'addCenterRewardDisplay',
		item = data.item, 
		level = data.level, 
		description = data.description,
		image = data.image
	})
end)


RegisterNUICallback('displayReward', function (data)

	SendNUIMessage({
		action = 'addCenterDisplay',
		item = data.item, 
		level = data.level, 
		description = data.description,
		image = data.image
	})
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if guiEnabled then


			DisableControlAction(0, 1,   true) -- LookLeftRight
			DisableControlAction(0, 2,   true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(0, 21,  true) -- disable sprint
			DisableControlAction(0, 24,  true) -- disable attack
			DisableControlAction(0, 25,  true) -- disable aim
			DisableControlAction(0, 47,  true) -- disable weapon
			DisableControlAction(0, 58,  true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75,  true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
		else
			Citizen.Wait(1000)
		end
	end
end)
