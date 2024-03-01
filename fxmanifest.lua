-- Resource Metadata
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- Resource Info
author '???'
description 'a bank'

shared_script '@ox_lib/init.lua'
shared_script '@salrp/lib/utils.lua'
shared_scripts {
    'shared/*.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}
