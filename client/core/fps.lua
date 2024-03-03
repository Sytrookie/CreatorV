FPS = 0
FRAMETIME = 0
CreateThread(function()
    while true do
        Wait(1000)

        local frameTime = GetFrameTime()
        local fps = math.floor(1.0 / frameTime)

        FPS = fps
        FRAMETIME = frameTime
    end
end)

local function fpsText(x,y, text)
    SetTextFont(FONTS['digital7'])
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
CreateThread(function()
    while true do
        Wait(10 * FRAMETIME)
        fpsText(0.005, 0.005, FPS)
    end
end)