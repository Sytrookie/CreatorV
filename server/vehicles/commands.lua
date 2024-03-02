COMMANDS[#COMMANDS+1] = {
    command = 'veh',
    help = 'Spawns a vehicle',
    params = {
        {name = 'model', help = 'Model name of the vehicle'},
    },
    func = function(source, args, raw)
        local model = args.model
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        local vec = vector4(coords.x, coords.y, coords.z, heading)

        lib.callback('basic:COMMANDS:spawnVehicle', source, function(veh, net)
            print(source, GetPlayerName(source), 'spawn vehicle')
            if veh then
                SetVehicleNumberPlateText(veh, 'CREATORV')
            end
        end, model, vec)
    end,
}

COMMANDS[#COMMANDS+1] = {
    command = 'dv',
    help = 'Delete nearest vehicle',
    func = function(source, args, raw)
        local coords = GetEntityCoords(GetPlayerPed(source))
        local v, vcoords = lib.getClosestVehicle(coords, 30.0, true)
        if v then
            DeleteEntity(v)
        end
    end,
}