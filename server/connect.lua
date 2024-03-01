AddEventHandler('playerJoining', function()
    local player = source
    print('joined', player, GetPlayerName(player))
end)
