fx_version 'adamant'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]]--

Author 'Ayazwai#3900'
version '1.0.2'
scriptname 'wais-bodycam-esx'

--[[ Resource Information ]]--

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    'config.lua',
    'server.lua'
}

escrow_ignore {
    'config.lua',
}

dependency 'ox_lib'