local peds = {
    's_m_y_construct_01',
    's_m_y_construct_02',
    's_m_y_dockwork_01',
}

function spawn(vec)

    local spawn = vec or vec4(41.889, -1146.994, 29.189, 330.863)

    FreezeEntityPosition(cache.ped, true)

    local pedmodel = peds[math.random(1, #peds)]
    lib.requestModel(pedmodel)

    SetPlayerModel(PlayerId(), pedmodel)

    RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

    SetEntityCoordsNoOffset(cache.ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
    SetEntityHeading(cache.ped, spawn.w)

    ClearPedTasksImmediately(cache.ped)

    local time = GetGameTimer()

    while (not HasCollisionLoadedAroundEntity(cache.ped) and (GetGameTimer() - time) < 5000) do
        Citizen.Wait(0)
    end

    ShutdownLoadingScreen() -- no loading screen yet :(

    FreezeEntityPosition(cache.ped, false)

    TriggerEvent('playerSpawned', spawn)

    -- Get the player ped
    local playerPed = PlayerPedId()

    -- List of all weapon hashes
    local weapons = {
        "WEAPON_KNIFE",
        "WEAPON_NIGHTSTICK",
        "WEAPON_HAMMER",
        "WEAPON_BAT",
        "WEAPON_GOLFCLUB",
        -- Add all other weapon hashes here
    }

    -- Give all weapons to the player ped
    for i, weapon in ipairs(weapons) do
        GiveWeaponToPed(playerPed, GetHashKey(weapon), 999, false, false)
    end
end

AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent('basic:commands:playerSpawned')
end)

CreateThread(function()
    spawn()
    while true do
        Wait(50)
        if cache.ped then
            if (diedAt and (GetTimeDifference(GetGameTimer(), diedAt) > 2000)) or respawnForced then
                local coords = GetEntityCoords(cache.ped)
                local heading = GetEntityHeading(cache.ped)
                spawn(vec4(coords.x, coords.y, coords.z, heading))
            end

            if IsEntityDead(cache.ped) then
                diedAt = GetGameTimer()
            else
                diedAt = nil
            end
        end
    end
end)

function forceRespawn()
    respawnForced = true
end