local weapon_names = require 'data.weapon_names'

local weaponHashTable = {}
for i, weapon in ipairs(weapon_names) do
    weaponHashTable[weapon] = GetHashKey(weapon)
end
return weaponHashTable