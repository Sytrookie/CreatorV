-- This file contains a Lua script that defines a table of commands.
-- Each command has a command name, a help message, optional parameters, and a function to execute when the command is called.
-- The commands table is populated with various commands, such as spawning a vehicle, deleting the nearest vehicle, grabbing current coordinates, and toggling noclip mode.
-- The commands are registered using the lib.addCommand function, which adds the command to the commands table and registers it with the appropriate functionality.
-- The script also exports an addCommand function, which allows external scripts to add new commands to the commands table.
-- Finally, there is a network event handler that sends the commands table to the client when triggered.
local commands = {}

commands[#commands+1] = {
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

        lib.callback('basic:commands:spawnVehicle', source, function(veh, net)
            print(source, GetPlayerName(source), 'spawn vehicle')
            if veh then
                SetVehicleNumberPlateText(veh, 'VELOCITY')
                SetVehicleHasBeenOwnedByPlayer(veh, true)
                SetEntityAsMissionEntity(veh, true, true)
                TaskWarpPedIntoVehicle(ped, veh, -1)
            end
        end, model, vec)
    end,
}

commands[#commands+1] = {
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

commands[#commands+1] = {
    command = 'coords',
    help = 'Grabs current coordinates',
    func = function(source, args, raw)
        lib.callback('basic:commands:coords', source, function(coords)
           print(source, GetPlayerName(source), 'coords', coords)
        end)
    end,
}

commands[#commands+1] = {
    command = 'noclip',
    help = 'Toggle noclip',
    func = function(source, args, raw)
        lib.callback('basic:noclip:toggle', source, function()
            print(source, GetPlayerName(source), 'noclip')
        end)
    end,
}

for i = 1, #commands do
    local command = commands[i]
    lib.addCommand(command.command, {
        help = command.help,
        params = command.params,
    }, command.func)
end


-- Adds a command to the list of available commands.
-- @param command (string) - The command name.
-- @param help (string) - The help text for the command.
-- @param params (table) - The parameters for the command.
-- @param func (function) - The function to be executed when the command is called.
exports('addCommand', function(command, help, params, func)
    commands[#commands+1] = {
        command = command,
        help = help,
        params = params,
        func = func,
    }
    lib.addCommand(command, {
        help = help,
        params = params,
    }, func)

    TriggerLatentClientEvent('basic:commands:getCommmands', -1, 2000, commands)
end)

exports.CreatorV:addCommand('help', 'an example of how to use this export', {}, function(source, args, raw)
    print('help command')
end)

RegisterNetEvent('basic:commands:getCommmands', function()
    local player = source
    TriggerLatentClientEvent('basic:commands:getCommmands', player, 2000, commands)
end)


-- https://overextended.dev/ox_lib/Modules/AddCommand/Server
-- lib.addCommand('veh', {
--     help = 'Gives an item to a player',
--     params = {
--         {
--             name = 'target',
--             type = 'playerId',
--             help = 'Target player\'s server id',
--         },
--         {
--             name = 'item',
--             type = 'string',
--             help = 'Name of the item to give',
--         },
--         {
--             name = 'count',
--             type = 'number',
--             help = 'Amount of the item to give, or blank to give 1',
--             optional = true,
--         },
--         {
--             name = 'metatype',
--             help = 'Sets the item\'s "metadata.type"',
--             optional = true,
--         },
--     },
--     restricted = 'group.admin'
-- }, function(source, args, raw)
--     local item = Items(args.item)
 
--     if item then
--         Inventory.AddItem(args.target, item.name, args.count or 1, args.metatype)
--     end
-- end)