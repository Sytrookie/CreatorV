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

lib.callback.register('basic:COMMANDS:spawnVehicle', function(model, coords)
    local veh, net = spawnVehicle(model, coords)
    return veh, net
end)

lib.callback.register('CreatorV:vehicles:list', function()
    local vehicles = GetAllVehicleModels()
    local vehicleNames = {}
    for i = 1, #vehicles do
        local model = vehicles[i]
        local name = GetLabelText(GetDisplayNameFromVehicleModel(model))
        table.insert(vehicleNames, {name = name, model = model})
    end

    table.sort(vehicleNames, function(a, b)
        return a.name < b.name
    end)

    local opts = {}

    for i = 1, #vehicleNames do
        table.insert(opts, {label = vehicleNames[i].name, value = vehicleNames[i].model})
    end

    local input = lib.inputDialog('Vehicles', {
        {type = 'select', label = 'Vehicle Model', options = opts, default = 'taxi'},
    })
    print(input, input[1])

    if input and input[1] then
        local coords = GetEntityCoords(cache.ped)
        local veh, net = spawnVehicle(input[1], coords)
        return veh, net
    end
end)