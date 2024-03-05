local resourceColors = {}
local usedColors = {}
local debugs = {}

function addDebug(id, text, tick, client)
    local res = GetInvokingResource()
    if not res then res = 'CV' end
    if not resourceColors[res] then
        resourceColors[res] = {255,255,255,255}
        repeat
            resourceColors[res] = {math.random(255), math.random(255), math.random(255), 255}
        until not usedColors[resourceColors[res]]
    end
    debugs[id] = {text = text, resource = res, color = resourceColors[res], tick = tick and function(id) 
        tick(id, debug)
    end, client = client}
    TriggerLatentClientEvent('CreatorV:hud:debug:addDebug', -1, 2000, id, text, res, resourceColors[res])
    -- print('addDebug', id, text, res, resourceColors[res], tick)
end
exports('addDebug', addDebug)

lib.callback.register('CreatorV:hud:debug:addDebug', function(player, id, text, tick)
    addDebug(id, text, tick, player)
end)

RegisterNetEvent('basic:COMMANDS:playerSpawned', function()
    local player = source
    if Player(player).state['basic:connect:first_spawn'] then
        for id, debug in pairs(debugs) do
            TriggerLatentClientEvent('CreatorV:hud:debug:addDebug', player, 2000, id, debug.text, debug.resource, debug.color)
        end
    end
end)

function updateDebug(id, text)
    debugs[id].text = tostring(text)
    local debug = debugs[id]
    -- print('update', id, text)
    TriggerLatentClientEvent('CreatorV:hud:debug:addDebug', -1, 2000, id, debug.text, debug.resource, debug.color)
end
exports('updateDebug', updateDebug)

CreateThread(function()
    local id = 'debugtest'
    addDebug(id, math.random(), function(id, debug)
        updateDebug(id, math.random())
    end)
    while true do
        Wait(1000)
        for id, debug in pairs(debugs) do
            -- print(id, debug.text, debug.tick)
            if debug.tick and type(debug.tick) == 'function' then
                local s,e = pcall(function()
                    if not debug.client then
                        -- print('ticking', id, debug.text, debug.tick)
                        debug.tick(id, debug)
                    end
                end)
                if not s then
                    print('error', e)
                    TriggerLatentClientEvent('CreatorV:hud:debug:addDebug', -1, 2000, id, 'ERROR', debug.resource, debug.color)
                else
                    TriggerLatentClientEvent('CreatorV:hud:debug:addDebug', -1, 2000, id, debug.text, debug.resource, debug.color)
                end
            end
        end
    end
end)