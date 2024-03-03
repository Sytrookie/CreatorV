local speed = 0
local MPH = 0
local KMH = 0
local speedstring = "0"
local first_start = true

local function speedoText(x,y, text)
    SetTextFont(FONTS['digital7'])
    SetTextProportional(0)
    SetTextScale(1.0, 1.0)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function speedoThreads(value)
    print('speedoThreads', value, cache.vehicle)
    if (value and not cache.vehicle) or cache.vehicle == value then
        while value ~= cache.vehicle do
            Wait(0)
        end
        print('initialize speedometer threads')
        CreateThread(function()
            while cache.vehicle and cache.vehicle == value do
                Wait(FRAMETIME * 1000)
                speed = GetEntitySpeed(cache.vehicle)
                MPH = speed * 2.236936
                KMH = speed * 3.6
                if MPH > 99 then
                    speedstring = string.format("%.0f", MPH)
                elseif MPH > 9 then
                    speedstring = string.format("0%.0f", MPH)
                else
                    speedstring = string.format("00%.0f", MPH)
                end
            end
        end)
        CreateThread(function()
            while cache.vehicle and cache.vehicle == value do
                Wait(FRAMETIME * 10)
                speedoText(0.185, 0.9, speedstring)
            end
        end)
    end
end

if first_start then
    first_start = false
    if cache.vehicle then
        local value = cache.vehicle
        speedoThreads(value, cache.vehicle)
    end
end

lib.onCache('vehicle', speedoThreads)