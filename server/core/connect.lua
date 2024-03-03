AddEventHandler('playerJoining', function()
    local player = source
    print('joined', player, GetPlayerName(player))
end)

AddEventHandler('basic:COMMANDS:playerSpawned', function()

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