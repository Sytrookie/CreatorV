-- This file contains a Lua script that defines a table of COMMANDS.
-- Each command has a command name, a help message, optional parameters, and a function to execute when the command is called.
-- The COMMANDS table is populated with various COMMANDS, such as spawning a vehicle, deleting the nearest vehicle, grabbing current coordinates, and toggling noclip mode.
-- The COMMANDS are registered using the lib.addCommand function, which adds the command to the COMMANDS table and registers it with the appropriate functionality.
-- The script also exports an addCommand function, which allows external scripts to add new COMMANDS to the COMMANDS table.
-- Finally, there is a network event handler that sends the COMMANDS table to the client when triggered.
COMMANDS = {}

COMMANDS[#COMMANDS+1] = {
    command = 'coords',
    help = 'Grabs current coordinates',
    func = function(source, args, raw)
        lib.callback('basic:COMMANDS:coords', source, function(coords)
           print(source, GetPlayerName(source), 'coords', coords)
        end)
    end,
}

COMMANDS[#COMMANDS+1] = {
    command = 'noclip',
    help = 'Toggle noclip',
    func = function(source, args, raw)
        lib.callback('basic:noclip:toggle', source, function()
            print(source, GetPlayerName(source), 'noclip')
        end)
    end,
}

COMMANDS[#COMMANDS+1] = {
    command = 'weap_all',
    help = 'Gives all weapons',
    func = function(source, args, raw)
        lib.callback('basic:COMMANDS:weap_all', source, function()
            print(source, GetPlayerName(source), 'weap_all')
        end)
    end,
}

for i = 1, #COMMANDS do
    local command = COMMANDS[i]
    lib.addCommand(command.command, {
        help = command.help,
        params = command.params,
    }, command.func)
end


-- Adds a command to the list of available COMMANDS.
-- @param command (string) - The command name.
-- @param help (string) - The help text for the command.
-- @param params (table) - The parameters for the command.
-- @param func (function) - The function to be executed when the command is called.
exports('addCommand', function(command, help, params, func)
    COMMANDS[#COMMANDS+1] = {
        command = command,
        help = help,
        params = params,
        func = func,
    }
    lib.addCommand(command, {
        help = help,
        params = params,
    }, func)

    TriggerLatentClientEvent('basic:COMMANDS:getCommmands', -1, 2000, COMMANDS)
end)

exports.CreatorV:addCommand('help', 'an example of how to use this export', {}, function(source, args, raw)
    print('help command')
end)

RegisterNetEvent('basic:COMMANDS:getCommmands', function()
    local player = source
    TriggerLatentClientEvent('basic:COMMANDS:getCommmands', player, 2000, COMMANDS)
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