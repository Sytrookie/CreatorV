-- Resource Metadata
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- Resource Info
author 'Sytrookie'
description 'CreatorV is a resource that allows you to create and test quick'
website 'https://github.com/Sytrookie/CreatorV'

shared_script '@ox_lib/init.lua'
shared_scripts {
    'shared/*.lua',
}

files {
    'data/*.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

dependencies {
    'ox_lib',
    'interact',
    '/server:7290',
    '/onesync',
}
