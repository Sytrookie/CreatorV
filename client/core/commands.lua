local commands = {}
local categories = {}
local LOADING_COMMANDS = true
local commandItems = {}
local lastReceivedCommand = 9999999999999999
lib.removeRadialItem('commands')
lib.removeRadialItem('commandMenu')

AddEventHandler('playerSpawned', function(spawn)
    if LocalPlayer.state['basic:connect:first_spawn'] then
        TriggerServerEvent('CreatorV:COMMANDS:getCommands')
    end
end)


function loadingCommands()
    while LOADING_COMMANDS do
        Wait(1000)
        if (GetGameTimer() - lastReceivedCommand) > 1000 then
            LOADING_COMMANDS = false
        end
    end
    print('done loading commands (probably)')
    local items = {}
    

    for category, _ in pairs(categories) do
        local add_context = {}
        for i = 1, #commands do
            if commands[i].category == category then
                add_context[#add_context+1] = commands[i].command
                add_context[#add_context+1] = commands[i].help
            end
        end
       
        local loaded = getRelevantIconAdv(category, add_context)
        items[#items+1] = {
            id = category,
            label = category,
            icon = 'fa-solid fa-'.. (loaded or 'download'),
            iconWidth = 12,
            iconHeight = 12,
            menu = category .. 'Menu',
            keepOpen = true,
        }
        
    end
    lib.registerRadial({
        id = 'commandsMenu',
        items = items,
    })
end

CreateThread(loadingCommands)

RegisterNetEvent('CreatorV:COMMANDS:getCommand', function(cmd)
    if not LOADING_COMMANDS then
        LOADING_COMMANDS = true
        CreateThread(loadingCommands)
    end

    cmd = msgpack.unpack(cmd)
    commands[#commands+1] = cmd
    print('got command', cmd.command)

    cmd.category = cmd.category or 'other' -- assign 'default' category if none is provided

    local loaded = getRelevantIconAdv(cmd.command, {cmd.help, cmd.category})
    local commandItem = {
        id = cmd.command,
        label = cmd.command,
        icon = loaded,
        iconWidth = 12,
        iconHeight = 12,
        onSelect = function(currentMenu, itemIndex)
            local command = cmd
            local params = {}
            if not command.params then command.params = {} end
            for i = 1, #command.params do
                local param = command.params[i]
                params[#params+1] = {
                    type = 'input',
                    label = param.name,
                    description = param.help .. ' - ' .. (param.type or 'string'),
                    default = '',
                    required = not param.optional,
                }
            end
            if #params > 0 then
                local inputs = lib.inputDialog(command.command .. ' - ' .. command.help, params, {})
                local args = ''
                for i = 1, #inputs do
                    args = args .. ' '
                    args = args .. tostring(inputs[i])
                end
                print('|command', command.command, args..'|')
                ExecuteCommand(command.command .. args)
            else
                ExecuteCommand(command.command)
            end
        end,
        keepOpen = false,
    }

    categories[cmd.category] = categories[cmd.category] or {}
    categories[cmd.category][#categories[cmd.category]+1] = cmd

    if not commandItems[cmd.category] then commandItems[cmd.category] = {} end
    commandItems[cmd.category][#commandItems[cmd.category]+1] = commandItem

    lib.registerRadial({
        id = cmd.category .. 'Menu',
        items = commandItems[cmd.category],
    })
    lastReceivedCommand = GetGameTimer()
end)

RegisterNetEvent('CreatorV:COMMANDS:getCommands', function(cmds)
    commands = msgpack.unpack(cmds)
    print('got commands', #commands)

    for i = 1, #commands do
        local command = commands[i]
        command.category = command.category or 'other' -- assign 'default' category if none is provided
        categories[command.category] = categories[command.category] or {}
        categories[command.category][#categories[command.category]+1] = command
    end

    table.sort(categories, function(a, b)
        return a.category < b.category
    end)

    for category, commands in pairs(categories) do
        if not commandItems[category] then commandItems[category] = {} end
        for i = 1, #commands do
            local cmd = commands[i]
            commandItems[category][#commandItems[category]+1] = {
                id = cmd.command,
                label = cmd.command,
                icon = 'fa-solid-fa-download',
                iconWidth = 12,
                iconHeight = 12,
                onSelect = function(currentMenu, itemIndex)
                    local command = cmd
                    local params = {}
                    if not command.params then command.params = {} end
                    for i = 1, #command.params do
                        local param = command.params[i]
                        params[#params+1] = {
                            type = 'input',
                            label = param.name,
                            description = param.help .. ' - ' .. (param.type or 'string'),
                            default = '',
                            required = not param.optional,
                        }
                    end
                    if #params > 0 then
                        local inputs = lib.inputDialog(command.command .. ' - ' .. command.help, params, {})
                        local args = ''
                        for i = 1, #inputs do
                            args = args .. ' '
                            args = args .. tostring(inputs[i])
                        end
                        print('|command', command.command, args..'|')
                        ExecuteCommand(command.command .. args)
                    else
                        ExecuteCommand(command.command)
                    end
                end,
                keepOpen = false,
            }
        end
        lib.registerRadial({
            id = category .. 'Menu',
            items = commandItems[category],
        })
    end

    for category, _ in pairs(categories) do

        local items = {}

        items[#items+1] = {
            id = category,
            label = category,
            icon = 'fa-solid-fa-download',
            iconWidth = 12,
            iconHeight = 12,
            menu = category .. 'Menu',
            keepOpen = true,
        }

        lib.registerRadial({
            id = 'commandsMenu',
            items = items,
        })
    end

    LOADING_COMMANDS = false

end)

lib.callback.register('basic:COMMANDS:coords', function()
    local coords = GetEntityCoords(cache.ped)
    local heading = GetEntityHeading(cache.ped)
    local vec = vec4(coords.x, coords.y, coords.z, heading)

    lib.inputDialog('Coords', {
        {type = 'input', label = 'vec3', default = ('%.3f, %.3f, %.3f'):format(coords.x, coords.y, coords.z)},
        {type = 'input', label = 'vec4', default = ('%.3f, %.3f, %.3f, %.3f'):format(coords.x, coords.y, coords.z, heading)},
    }, {})
    
    return vec
end)

lib.addRadialItem({
    id = 'loading_commands',
    label = 'Loading  \n  Cmds  \n  ...',
    icon = 'fa-solid-fa-download',
    iconWidth = 12,
    iconHeight = 12,
    keepOpen = true,
    onSelect = function(currentMenu, itemIndex)
        print('loading commands')
    end,
})

while LOADING_COMMANDS do
    Wait(0)
end

lib.removeRadialItem('loading_commands')

local loaded = getRelevantIconAdv('commands', {'cmd', 'hacker', 'programming', 'coding'})
lib.addRadialItem({
    id = 'commands',
    label = 'Commands',
    icon = loaded,
    iconWidth = 12,
    iconHeight = 12,
    -- onSelect = function(currentMenu, itemIndex)

    -- end,
    menu = 'commandsMenu',
    keepOpen = true,
})

-- RegisterNetEvent('CreatorV:COMMANDS:getCommands', function(cmds)
--     commands = cmds
--     print('got commands', #commands)

--     local categories = {}
--     for i = 1, #commands do
--         local command = commands[i]
--         command.category = command.category or 'default' -- assign 'default' category if none is provided
--         categories[command.category] = categories[command.category] or {}
--         categories[command.category][#categories[command.category]+1] = command
--     end

--     for category, commands in pairs(categories) do
--         local commandsItems = {}
--         for i = 1, #commands do
--             local command = commands[i]
--             commandsItems[#commandsItems+1] = {
--                 id = command.command,
--                 label = command.command,
--                 icon = 'fa-solid-fa-download',
--                 iconWidth = 12,
--                 iconHeight = 12,
--                 onSelect = function(currentMenu, itemIndex)
--                     local command = commands[i]
--                     local params = {}
--                     if not command.params then command.params = {} end
--                     for i = 1, #command.params do
--                         local param = command.params[i]
--                         params[#params+1] = {
--                             type = 'input',
--                             label = param.name,
--                             description = param.help .. ' - ' .. (param.type or 'string'),
--                             default = '',
--                             required = not param.optional,
--                         }
--                     end
--                     if #params > 0 then
--                         local inputs = lib.inputDialog(command.command .. ' - ' .. command.help, params, {})
--                         local args = ''
--                         for i = 1, #inputs do
--                             args = args .. ' '
--                             args = args .. tostring(inputs[i])
--                         end
--                         print('|command', command.command, args..'|')
--                         ExecuteCommand(command.command .. args)
--                     else
--                         ExecuteCommand(command.command)
--                     end
--                 end,
--                 keepOpen = false,
--             }
--         end
--         lib.registerRadial({
--             id = category .. 'Menu',
--             items = commandsItems,
--         })
--         print(category .. 'Menu', #commandsItems)
--     end
-- end)
