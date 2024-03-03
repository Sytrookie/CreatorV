local weapon_hashtable = require 'data.weapon_hashtable'

lib.callback.register('basic:COMMANDS:weap_all', function()
    for name, hash in pairs(weapon_hashtable) do
        print(name, hash)
        GiveWeaponToPed(cache.ped, hash, 999, false, true)
        Wait(10) -- feels neater to have them "pop" in
    end
end)
