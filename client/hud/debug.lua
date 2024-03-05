local enabled = true
local debugs = {}
local count = -1

lib.addRadialItem({
    id = 'CreatorV:debug',
    icon = 'fas fa-bug',
    label = 'Debug',
    onSelect = function()
        enabled = not enabled
    end
})

local function debugText(x,y, text, color)
    SetTextFont(FONTS['digital7'])
    SetTextProportional(0)
    SetTextScale(0.35, 0.35)
    local color = color or {255, 255, 255, 255}
    SetTextColour(color[1], color[2], color[3], color[4])
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

RegisterNetEvent('CreatorV:hud:debug:addDebug', function(id, text, res, color)
    if not debugs[id] then
        count = count + 1
        debugs[id] = {text = text, resource = res, color = color, idx = count}
    else
        local i = debugs[id].idx
        debugs[id] = {text = text, resource= res, color = color, idx = i}
    end
end)

function addDebug(id, text, tick)
    id = id .. GetPlayerServerId(PlayerId())
    lib.callback('CreatorV:hud:debug:addDebug', 1000, function() end, id, text)
    CreateThread(function()
        while true do
            Wait(1000)
            if tick then
                local s,e = pcall(function()
                    tick(id, debugs[id])
                end)
                if not s then
                    print('error', e)
                    lib.callback('CreatorV:hud:debug:addDebug', 1000, function() end, id, "ERROR")
                elseif debugs[id] then
                    lib.callback('CreatorV:hud:debug:addDebug', 1000, function() end, id, debugs[id].text)
                else
                    lib.callback('CreatorV:hud:debug:addDebug', 1000, function() end, id, text)
                end
            end
        end
    end)
end
exports('addDebug', addDebug)

function updateDebug(id, text)
    if not debugs[id] then return end
    debugs[id].text = tostring(text)
    local debug = debugs[id]
    lib.callback('CreatorV:hud:debug:addDebug', 1000, function() end, id, text, debug.resource, debug.color)
end
exports('updateDebug', updateDebug)

CreateThread(function()
    -- addDebug('frametime', FRAMETIME, function(id, debug)
    --     updateDebug(id, FRAMETIME)
    -- end)
    Wait(1000)
    addDebug('fps', FPS, function(id, debug)
        updateDebug(id, FPS)
    end)

    local xPer = 0.02
    while true do
        Wait(10 * FRAMETIME)
        if enabled then
            for id, debug in pairs(debugs) do
                local i = debug.idx
                debugText(0.8, 0.1 + (i * xPer), i .. ' ' .. id .. ': ' .. debug.text, debug.color)
            end
        end
    end
end)