local getModLabel = require('client.vehiclemods.utils.getModLabel')
local originalMods = {}
local originalTurbo
local lastIndex
local VehicleClass = require('client.vehiclemods.utils.enums.VehicleClass')

local function priceLabel(price)
    if type(price) ~= 'table' then
        return ('%s%s'):format(VMODSConfig.Currency, price)
    end

    local copy = table.clone(price)
    table.remove(copy, 1)

    for i = 1, #copy do
        copy[i] = ('%d: %s%s'):format(i, VMODSConfig.Currency, copy[i])
    end

    return table.concat(copy, ' | ')
end

local Config = {}
VMODSConfig.Mods = {
    { id = 0,  label = 'Spoiler',              category = 'parts' },
    { id = 1,  label = 'Front Bumper',         category = 'parts' },
    { id = 2,  label = 'Rear Bumper',          category = 'parts' },
    { id = 3,  label = 'Side Skirt',           category = 'parts' },
    { id = 4,  label = 'Exhaust',              category = 'parts' },
    { id = 5,  label = 'Roll Cage',            category = 'parts' },
    { id = 6,  label = 'Grille',               category = 'parts' },
    { id = 7,  label = 'Hood',                 category = 'parts' },
    { id = 8,  label = 'Left Fender',          category = 'parts' },
    { id = 9,  label = 'Right Fender',         category = 'parts' },
    { id = 10, label = 'Roof',                 category = 'parts' },
    { id = 11, label = 'Engine Upgrade',       category = 'performance' },
    { id = 12, label = 'Brake Upgrade',        category = 'performance' },
    { id = 13, label = 'Transmission Upgrade', category = 'performance' },
    { id = 14, label = 'Horns',                category = 'parts' },
    { id = 15, label = 'Suspension Upgrade',   category = 'performance' },
    { id = 16, label = 'Armor Upgrade',        category = 'performance', enabled = false },
    { id = 17, label = 'Nitrous',              category = 'performance', enabled = false },
    -- { id = 18, label = 'Turbo Upgrade', category = 'performance' },
    { id = 19, label = 'Subwoofer',            category = 'parts' },
    -- { id = 20, label = 'Tyre smoke',                category = 'colors' },
    { id = 21, label = 'Hydraulics',           category = 'parts' },
    -- { id = 22, label = 'Xenon lights',         category = 'colors' },
    -- { id = 23, label = 'Wheels', category = 'parts' },
    -- { id = 24, label = 'Rear wheels or hydraulics', category = 'parts' },
    { id = 25, label = 'Plate holder',         category = 'parts' },
    { id = 26, label = 'Vanity Plates',        category = 'parts' },
    { id = 27, label = 'Trim A',               category = 'parts' },
    { id = 28, label = 'Ornaments',            category = 'parts' },
    { id = 29, label = 'Dashboard',            category = 'parts' },
    { id = 30, label = 'Dial',                 category = 'parts' },
    { id = 31, label = 'Door Speaker',         category = 'parts' },
    { id = 32, label = 'Seats',                category = 'parts' },
    { id = 33, label = 'Steering Wheel',       category = 'parts' },
    { id = 34, label = 'Shifter Leaver',       category = 'parts' },
    { id = 35, label = 'Plaque',               category = 'parts' },
    { id = 36, label = 'Speaker',              category = 'parts' },
    { id = 37, label = 'Trunk',                category = 'parts' },
    { id = 38, label = 'Hydraulic',            category = 'parts' },
    { id = 39, label = 'Engine Block',         category = 'parts' },
    { id = 40, label = 'Air Filter',           category = 'parts' },
    { id = 41, label = 'Strut',                category = 'parts' },
    { id = 42, label = 'Arch Cover',           category = 'parts' },
    { id = 43, label = 'Aerial',               category = 'parts' },
    { id = 44, label = 'Trim B',               category = 'parts' },
    { id = 45, label = 'Fuel Tank',            category = 'parts' },
    { id = 46, label = 'Left door',            category = 'parts' },
    { id = 47, label = 'Right door',           category = 'parts' },
    -- { id = 48, label = 'Livery',               category = 'colors' },
    { id = 49, label = 'Lightbar',             category = 'parts' },
}

local function performance()
    local options = {}

    for _, mod in ipairs(VMODSConfig.Mods) do
        local modCount = GetNumVehicleMods(vehicle, mod.id)

        if mod.category ~= 'performance'
        or mod.enabled == false
        or modCount == 0
        then goto continue end

        local modLabels = {}
        modLabels[1] = 'Stock'
        for i = -1, modCount - 1 do
            modLabels[i + 2] = getModLabel(vehicle, mod.id, i)
        end

        local currentMod = GetVehicleMod(vehicle, mod.id)
        originalMods[mod.id] = currentMod

        options[#options+1] = {
            id = mod.id,
            label = mod.label,
            description = priceLabel(VMODSConfig.Prices[mod.id]),
            values = modLabels,
            close = true,
            defaultIndex = currentMod + 2,
            set = function(index)
                SetVehicleMod(vehicle, mod.id, index - 2, false)
                return currentMod == index - 2, ('%s installed'):format(modLabels[index])
            end,
            restore = function()
                SetVehicleMod(vehicle, mod.id, originalMods[mod.id], false)
            end
        }

        ::continue::
    end

    originalTurbo = IsToggleModOn(vehicle, 18)
    if GetVehicleClass(vehicle) ~= VehicleClass.Cycles then
        options[#options+1] = {
            id = 18,
            label = 'Turbo',
            description = ('%s%s'):format(VMODSConfig.Currency, VMODSConfig.Prices[18]),
            values = {'Disabled', 'Enabled'},
            close = true,
            defaultIndex = originalTurbo and 2 or 1,
            set = function(index)
                ToggleVehicleMod(vehicle, 18, index == 2)
                return originalTurbo == (index == 2), ('Turbo %s'):format(index == 2 and 'enabled' or 'disabled')
            end,
            restore = function()
                ToggleVehicleMod(vehicle, 18, originalTurbo)
            end
        }
    end

    table.sort(options, function(a, b)
        return a.label < b.label
    end)

    return options
end

local menu = {
    id = 'customs-performance',
    title = 'Performance',
    canClose = true,
    disableInput = false,
    options = {},
    position = 'top-left',
}

local function onSubmit(selected, scrollIndex)
    for _, v in pairs(menu.options) do
        v.restore()
    end

    local duplicate, desc = menu.options[selected].set(scrollIndex)

    local success = require('client.vehiclemods.utils.installMod')(duplicate, menu.options[selected].id, {
        description = desc,
    }, scrollIndex)

    if not success then menu.options[selected].restore() end

    lib.setMenuOptions(menu.id, performance())
    lib.showMenu(menu.id, lastIndex)
end

menu.onSideScroll = function(selected, scrollIndex)
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    local option = menu.options[selected]
    option.set(scrollIndex)
end

menu.onClose = function()
    for _, v in pairs(menu.options) do
        v.restore()
    end
    lib.showMenu(mainMenuId, mainLastIndex)
end

menu.onSelected = function(selected)
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    lastIndex = selected
end

return function()
    menu.options = performance()
    lib.registerMenu(menu, onSubmit)
    return menu.id
end