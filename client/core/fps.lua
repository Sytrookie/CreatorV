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