AddEventHandler('playerJoining', function()
    local player = source
    print('joined', player, GetPlayerName(player))
    Player(player).state['basic:connect:first_spawn'] = true
end)

RegisterNetEvent('basic:COMMANDS:playerSpawned', function()
    local player = source
    Player(player).state['basic:connect:first_spawn'] = false
end)

AddStateBagChangeHandler('basic:died', nil, function(bagName, key, value)
    local source = GetPlayerFromStateBagName(bagName)
    if entity == 0 then return end
    if value then
        print(GetPlayerName(source), 'died')
    else
        print(GetPlayerName(source), 'respawned')
    end
end)