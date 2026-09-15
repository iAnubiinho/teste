fx_version 'cerulean'
games {'gta5'}
description 'MarkoMods.com Shotgun 590'
files{
	'**/markomods-590-components.meta',
	'**/markomods-590-archetypes.meta',
	'**/markomods-590-animations.meta',
	'**/markomods-590-pedpersonality.meta',
	'**/markomods-590.meta',
}
data_file 'WEAPONCOMPONENTSINFO_FILE' '**/markomods-590-components.meta'
data_file 'WEAPON_METADATA_FILE' '**/markomods-590-archetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/markomods-590-animations.meta'
data_file 'PED_PERSONALITY_FILE' '**/markomods-590-pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/markomods-590.meta'
client_script 'cl_weaponNames.lua'
escrow_ignore {
	'stream/**/*.ytd',
	'data/**/*.meta',
	'cl_weaponNames.lua'
}
lua54 'yes'
