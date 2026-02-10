fx_version 'cerulean'
game 'gta5'

author "Spartan Estlandia roleplay"
version '1.3.0'
lua54 'yes'

shared_scripts {
    'shared/*',
    '@ox_lib/init.lua'
}

client_scripts {
	'client/*',
}

server_scripts {
    'server/*',
}

escrow_ignore {
    'client/*',
    'server/*',
	'shared/*.lua',
    "[IMG-Minigames]/minigames/client/**/*",
	"[IMG-Minigames]/minigames/web/**/*",
	"[IMG-Minigames]/minigames/build/**/*",
}
dependency '/assetpacks'