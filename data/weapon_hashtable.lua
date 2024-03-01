require 'data.weapon_names'

local weaponHashTable = {}
for i, weapon in ipairs(weaponNames) do
    weaponHashTable[weapon] = GetHashKey(weapon)
end
return weaponHashTable