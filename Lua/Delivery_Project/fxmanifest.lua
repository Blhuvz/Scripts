fx_version 'cerulean'
game 'gta5'

author 'Blhuvz'
description 'Basic delivery script using QB-Core (more features will be added shortly)'

shared_script '@qb-core/shared/locale.lua'

server_scripts {
    'config.lua',
    'server/server.lua'
}

client_scripts {
    'config.lua',
    'client/client.lua'
}

dependencies {
    'qb-core'
}
