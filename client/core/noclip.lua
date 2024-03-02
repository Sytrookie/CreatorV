local Config = {
    Controls = {
        -- FiveM IO Parameter ID: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        toggle = 'PAGEDOWN',
        changeSpeed = 'LSHIFT', 
        camMode = 'PAGEUP', 
        -- FiveM Controls: https://docs.fivem.net/game-references/controls/
        goUp = 22, -- SPACEBAR
        goDown = 36, -- LEFT CTRL
        turnLeft = 34, -- A
        turnRight = 35, -- D
        goForward = 32,  -- W
        goBackward = 33, -- S
    },

    Speeds = {
        -- You can add or edit existing speeds with relative label
        { speed = 0 },
        { speed = 0.5 },
        { speed = 2 },
        { speed = 5 },
        { speed = 10 },
        { speed = 15 },
    },

    Offsets = {
        y = 0.2, -- Forward and backward movement speed multiplier
        z = 0.2, -- Upward and downward movement speed multiplier
        h = 3, -- Rotation movement speed multiplier
    },
}

local NoClipStatus = false
local NoClipEntity = false
local FollowCamMode = true
local index = 1
local CurrentSpeed = Config.Speeds[index].speed

Citizen.CreateThread(function()
    while true do
        while NoClipStatus do
            DisableAllControlActions()
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)

            local yoff = 0.0
            local zoff = 0.0

			if IsDisabledControlPressed(0, Config.Controls.goForward) then
                yoff = Config.Offsets.y
			end
			
            if IsDisabledControlPressed(0, Config.Controls.goBackward) then
                yoff = -Config.Offsets.y
			end

            if IsDisabledControlPressed(0, Config.Controls.goUp) then
                zoff = Config.Offsets.z
			end
			
            if IsDisabledControlPressed(0, Config.Controls.goDown) then
                zoff = -Config.Offsets.z
			end

            if not FollowCamMode and IsDisabledControlPressed(0, Config.Controls.turnLeft) then
                SetEntityHeading(cache.ped, GetEntityHeading(cache.ped)+Config.Offsets.h)
			end
			
            if not FollowCamMode and IsDisabledControlPressed(0, Config.Controls.turnRight) then
                SetEntityHeading(cache.ped, GetEntityHeading(cache.ped)-Config.Offsets.h)
			end
			
            local newPos = GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, yoff * (CurrentSpeed + 0.3), zoff * (CurrentSpeed + 0.3))
            local heading = GetEntityHeading(NoClipEntity)
            
            SetEntityVelocity(NoClipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(NoClipEntity, 0.0, 0.0, 0.0, 0, false)
            if(FollowCamMode) then
                SetEntityHeading(NoClipEntity, GetGameplayCamRelativeHeading());
            else
                SetEntityHeading(NoClipEntity, heading);
            end
            SetEntityCoordsNoOffset(NoClipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

            SetLocalPlayerVisibleLocally(true);
            Citizen.Wait(0)
        end
        Citizen.Wait(0)
    end
end)

function toggleNoClip()
    if not NoClipStatus then
        if IsPedInAnyVehicle(cache.ped, false) then
            NoClipEntity = GetVehiclePedIsIn(cache.ped, false)
        else
            NoClipEntity = cache.ped
        end

        SetEntityAlpha(NoClipEntity, 51, 0)
        if(NoClipEntity ~= cache.ped) then
            SetEntityAlpha(cache.ped, 51, 0)
        end
    else
        index = 1
        CurrentSpeed = Config.Speeds[index].speed
        ResetEntityAlpha(NoClipEntity)
        if(NoClipEntity ~= cache.ped) then
            ResetEntityAlpha(cache.ped)
        end
    end

    SetEntityCollision(NoClipEntity, NoClipStatus, NoClipStatus)
    FreezeEntityPosition(NoClipEntity, not NoClipStatus)
    SetEntityInvincible(NoClipEntity, not NoClipStatus)
    SetEntityVisible(NoClipEntity, NoClipStatus, not NoClipStatus);
    SetEveryoneIgnorePlayer(cache.ped, not NoClipStatus);
    SetPoliceIgnorePlayer(cache.ped, not NoClipStatus);

    NoClipStatus = not NoClipStatus
    LocalPlayer.state:set('noclip', NoClipStatus, true)
end


lib.callback.register('arculus-admin:noclip', function()
    toggleNoClip()
end)


RegisterCommand('noclip', function()
    toggleNoClip()
end)

RegisterCommand('noclip_cam', function()
        FollowCamMode = not FollowCamMode
end)

RegisterCommand('noclip_speed', function()
    if index ~= #Config.Speeds then
        index = index+1
        CurrentSpeed = Config.Speeds[index].speed
    else
        CurrentSpeed = Config.Speeds[1].speed
        index = 1
    end
    print(index, CurrentSpeed)
    Wait(100)
end)

RegisterKeyMapping('noclip', 'Toggle NoClip', 'keyboard', Config.Controls.toggle)
RegisterKeyMapping('noclip_cam', 'NoClip Camera', 'keyboard', Config.Controls.camMode)
RegisterKeyMapping('noclip_speed', 'NoClip Speed', 'keyboard', Config.Controls.changeSpeed)