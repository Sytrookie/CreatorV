-- This file contains a Lua script that defines a table of COMMANDS.
-- Each command has a command name, a help message, optional parameters, and a function to execute when the command is called.
-- The COMMANDS table is populated with various COMMANDS, such as spawning a vehicle, deleting the nearest vehicle, grabbing current coordinates, and toggling noclip mode.
-- The COMMANDS are registered using the lib.addCommand function, which adds the command to the COMMANDS table and registers it with the appropriate functionality.
-- The script also exports an addCommand function, which allows external scripts to add new COMMANDS to the COMMANDS table.
-- Finally, there is a network event handler that sends the COMMANDS table to the client when triggered.
COMMANDS = {}

-- Adds a command to the list of available COMMANDS.
-- @param command (string) - The command name.
-- @param category (string) -- The category of the command.
-- @param help (string) - The help text for the command.
-- @param params (table) - The parameters for the command.
-- @param func (function) - The function to be executed when the command is called.
function addCommand(command, category, help, params, func)
    local id = #COMMANDS+1
    COMMANDS[id] = {
        command = command,
        category = category,
        help = help,
        params = params,
        func = func,
    }
    lib.addCommand(command, {
        help = help,
        params = params,
    }, func)

    print('send command', command, category, help, id, '# of COMMANDS', #COMMANDS)
    SetTimeout(1000, function()
        TriggerLatentClientEvent('CreatorV:COMMANDS:getCommand', -1, 2000, msgpack.pack(COMMANDS[id]))
    end)
end
exports('addCommand', addCommand)

addCommand('coords', 'Core', 'Grabs current coordinates', {}, function(source, args, raw)
    lib.callback('basic:COMMANDS:coords', source, function(coords)
       print(source, GetPlayerName(source), 'coords', coords)
    end)
end)

addCommand('noclip', 'Core', 'Toggle noclip', {}, function(source, args, raw)
    lib.callback('basic:noclip:toggle', source, function()
        print(source, GetPlayerName(source), 'noclip')
    end)
end)

-- example export command
-- exports.CreatorV:addCommand('help', 'an example of how to use this export', {}, function(source, args, raw)
--     print('help command')
-- end)

RegisterNetEvent('CreatorV:COMMANDS:getCommands', function()
    local player = source
    for i = 1, #COMMANDS do
        print('send command', COMMANDS[i].command, COMMANDS[i].category, COMMANDS[i].help, i, '# of COMMANDS', #COMMANDS)
        SetTimeout(1000, function()
            TriggerLatentClientEvent('CreatorV:COMMANDS:getCommand', player, 2000, msgpack.pack(COMMANDS[i]))
        end)
    end
    -- TriggerLatentClientEvent('CreatorV:COMMANDS:getCommands', player, 2000, msgpack.pack(COMMANDS))
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