local peds = {
    's_m_y_construct_01',
    's_m_y_construct_02',
    's_m_y_dockwork_01',
}

function spawn(vec)

    local spawn = vec or vec4(-178.145, -164.105, 44.032, 160.695)

    if IsEntityDead(cache.ped) then
        NetworkResurrectLocalPlayer(spawn.x , spawn.y, spawn.z, true, true, false)
    end

    local pedmodel = peds[math.random(1, #peds)]
    lib.requestModel(pedmodel)

    SetPlayerModel(PlayerId(), pedmodel)

    RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

    SetEntityCoordsNoOffset(cache.ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
    SetEntityHeading(cache.ped, spawn.w)
    
    FreezeEntityPosition(cache.ped, true)

    local time = GetGameTimer()
    while (not HasCollisionLoadedAroundEntity(cache.ped) and (GetGameTimer() - time) < 5000) do
        Wait(0)
    end

    SetEntityCoordsNoOffset(cache.ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
    SetEntityHeading(cache.ped, spawn.w)

    ClearPedTasksImmediately(cache.ped)

    ShutdownLoadingScreen() -- no loading screen yet :(

    FreezeEntityPosition(cache.ped, false)

    TriggerEvent('playerSpawned', spawn)
    

end

AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent('basic:COMMANDS:playerSpawned')
end)

SetTimeout(500, function()
    if LocalPlayer.state['basic:connect:first_spawn'] then
        spawn()
    end
    LocalPlayer.state:set('basic:died', false, true)
    while true do
        Wait(1000)
        if cache.ped then
            if (LocalPlayer.state['basic:died'] and (GetCloudTimeAsInt() - LocalPlayer.state['basic:died'] > 2)) or respawnForced then
                local coords = GetEntityCoords(cache.ped)
                local heading = GetEntityHeading(cache.ped)
                spawn(vec4(coords.x, coords.y, coords.z, heading))
                LocalPlayer.state:set('basic:died', false, true)
            end

            if (IsPlayerDead(PlayerId()) or IsEntityDead(cache.ped)) and not LocalPlayer.state['basic:died'] then
                LocalPlayer.state:set('basic:died', GetCloudTimeAsInt(), true)
            end
        end
    end
end)

function forceRespawn()
    respawnForced = true
end