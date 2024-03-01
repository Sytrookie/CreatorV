local commands = {}

local commandsItems = {}

AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent('basic:commands:getCommmands')
end)

RegisterNetEvent('basic:commands:getCommmands', function(cmds)
    commands = cmds
    print('got commands', #commands)
    for i = 1, #commands do
        local command = commands[i]
        commandsItems[#commandsItems+1] = {
            id = command.command,
            label = command.command,
            icon = 'fa-solid-fa-download',
            iconWidth = 12,
            iconHeight = 12,
            onSelect = function(currentMenu, itemIndex)
                local command = commands[i]
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
                --lib.triggerServerEvent('basic:commands:runCommand', command.command, args)
            end,
            keepOpen = false,
        }
    end
    lib.registerRadial({
        id = 'commandsMenu',
        items = commandsItems,
    })
    print('commandsItems', #commandsItems)
end)

function spawnVehicle(model, coords)
    lib.requestModel(model)
    local veh = CreateVehicle(GetHashKey(model), coords.x, coords.y, coords.z, coords.w, true, false)
    while not DoesEntityExist(veh) do
        Wait(0)
    end
    SetVehicleOnGroundProperly(veh)

    SetPedIntoVehicle(cache.ped, veh, -1)

    return veh, VehToNet(veh)
end

lib.callback.register('basic:commands:spawnVehicle', function(model, coords)
    local veh, net = spawnVehicle(model, coords)
    return veh, net
end)

lib.callback.register('basic:commands:coords', function()
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
    id = 'commands',
    label = 'Commands',
    icon = 'fa-solid-fa-download',
    iconWidth = 12,
    iconHeight = 12,
    -- onSelect = function(currentMenu, itemIndex)

    -- end,
    menu = 'commandsMenu',
    keepOpen = true,
})