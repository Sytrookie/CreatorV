addCommand('veh', 'Vehicles', 'Spawns a vehicle', 
    {{name = 'model', help = 'Model name of the vehicle'}}, 
    function(source, args, raw)
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

end)

addCommand('dv', 'Vehicles', 'Deletes nearest vehicle', {}, function(source, args, raw)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local v, vcoords = lib.getClosestVehicle(coords, 30.0, true)
    if v then
        DeleteEntity(v)
    end
end)

addCommand('vehmods', 'Vehicles', 'Opens a vehicle garage mode menu for customization or your sick hot rod', {}, function(source, args, raw)
    lib.callback('CreatorV:vehiclemods:client:openMenu', source, function()
        
    end)
end)

addCommand('vehicles', 'Vehicles', 'Lists all vehicles', {}, function(source, args, raw)
    lib.callback('CreatorV:vehicles:list', source, function()
        
    end)
end)