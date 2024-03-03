function progBar(x, y, w, h, value, max, r, g, b, a)
    local bar = value / max
    local barWidth = w * bar
    local barX = x - w / 2 + barWidth / 2
    local barY = y - h / 2
    local barHeight = h
    DrawRect(barX, barY, barWidth, barHeight, r, g, b, a)
end

local function sprogText(x,y,scale, text)
    SetTextFont(FONTS['digital7'])
    SetTextProportional(0)
    SetTextScale(scale or 1.0, scale or 1.0)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function sprogBar(x, y, value, max, scale, color1, color2)
    if not color1 then
        color1 = '#359A47'
    end

    if not color2 then
        color2 = '#EB2427'
    end

    value = math.ceil(value)
    local string = '||||||||||'
    local bar = math.ceil((value / max) * 10)
    local barString = string.sub(string, 1, bar)
    local barString2 = string.sub(string, bar + 1, 10)
    sprogText(x, y, scale, "<font color='"..color1.."'>"..barString .. '</font>' .. "<font color='"..color2.."'>"..barString2..'</font>')
end