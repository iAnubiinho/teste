fx_version 'cerulean'
games {'gta5'}
description 'Markomods.com x17'
files{
   '**/markomods-x17-components.meta',
   '**/markomods-x17-archetypes.meta',
   '**/markomods-x17-animations.meta',
   '**/markomods-x17-components.meta',
   '**/markomods-x17-pedpersonality.meta',
   '**/markomods-x17.meta',
}
data_file 'WEAPONCOMPONENTSINFO_FILE' '**/markomods-x17-components.meta'
data_file 'WEAPON_METADATA_FILE' '**/markomods-x17-archetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/markomods-x17-animations.meta'
data_file 'PED_PERSONALITY_FILE' '**/markomods-x17-pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/markomods-x17.meta'
client_script 'cl_weaponNames.lua'
escrow_ignore {
	'stream/**/*.ytd',
	'data/**/*.meta',
	'cl_weaponNames.lua'
}
lua54 'yes'
