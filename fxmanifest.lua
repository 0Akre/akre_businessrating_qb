fx_version 'cerulean'
game 'gta5'

author 'Akre'
lua54 'yes'

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
    '@oxmysql/lib/MySQL.lua'

} 


shared_scripts {
    '@ox_lib/init.lua',   
    'config.lua'
}
