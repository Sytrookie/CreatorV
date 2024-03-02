function spawnVehicle(model, coords)
    local mhash = GetHashKey(model)
    if IsModelValid(mhash) then
        lib.requestModel(model)
        local veh = CreateVehicle(mhash, coords.x, coords.y, coords.z, coords.w, true, false)

        local spawned = lib.waitFor(function()
            return DoesEntityExist(veh)
        end, 'Failed to create vehicle', 10000)

        if not spawned then
            return
        end

        SetVehicleOnGroundProperly(veh)

        SetPedIntoVehicle(cache.ped, veh, -1)

        SetModelAsNoLongerNeeded(mhash)
    else
        print('Invalid model', model, mhash)
    end
    return veh, VehToNet(veh)
end

lib.callback.register('basic:commands:spawnVehicle', function(model, coords)
    local veh, net = spawnVehicle(model, coords)
    return veh, net
end)