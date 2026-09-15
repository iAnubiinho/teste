fx_version 'cerulean'
games {'gta5'}
description 'Markomods.com 2S'
files{
	'**/markomods-2s-components.meta',
	'**/markomods-2s-archetypes.meta',
	'**/markomods-2s-animations.meta',
	'**/markomods-2s-pedpersonality.meta',
	'**/markomods-2s.meta',
}
data_file 'WEAPONCOMPONENTSINFO_FILE' '**/markomods-2s-components.meta'
data_file 'WEAPON_METADATA_FILE' '**/markomods-2s-archetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/markomods-2s-animations.meta'
data_file 'PED_PERSONALITY_FILE' '**/markomods-2s-pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/markomods-2s.meta'
client_script 'cl_weaponNames.lua'
escrow_ignore {
	'stream/**/*.ytd',
	'data/**/*.meta',
	'cl_weaponNames.lua'
}
lua54 'yes'
