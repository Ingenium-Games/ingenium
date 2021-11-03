conf.weapon = {}

local WeaponClasses = {
    ['SMALL_CALIBER'] = 1,
    ['MEDIUM_CALIBER'] = 2,
    ['HIGH_CALIBER'] = 3,
    ['SHOTGUN'] = 4,
    ['CUTTING'] = 5,
    ['LIGHT_IMPACT'] = 6,
    ['HEAVY_IMPACT'] = 7,
    ['EXPLOSIVE'] = 8,
    ['FIRE'] = 9,
    ['SUFFOCATING'] = 10,
    ['OTHER'] = 11,
    ['WILDLIFE'] = 12,
    ['NOTHING'] = 13
}

conf.weapon.weapons = {
    
}

conf.weapon.classes = {
    --[[ Small Caliber ]]--
    [`WEAPON_PISTOL`] = WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPISTOL`] = WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_APPISTOL`] = WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPDW`] = WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MACHINEPISTOL`] = WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MICROSMG`] = WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MINISMG`] = WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_PISTOL_MK2`] = WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_SNSPISTOL`] = WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_SNSPISTOL_MK2`] = WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_VINTAGEPISTOL`] = WeaponClasses['SMALL_CALIBER'],

    --[[ Medium Caliber ]]--
    [`WEAPON_ADVANCEDRIFLE`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_ASSAULTSMG`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_BULLPUPRIFLE`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_BULLPUPRIFLE_MK2`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE_MK2`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_COMPACTRIFLE`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_DOUBLEACTION`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_GUSENBERG`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_HEAVYPISTOL`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_MARKSMANPISTOL`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_PISTOL50`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_REVOLVER`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_REVOLVER_MK2`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SMG`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SMG_MK2`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SPECIALCARBINE`] = WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SPECIALCARBINE_MK2`] = WeaponClasses['MEDIUM_CALIBER'],

    --[[ High Caliber ]]--
    [`WEAPON_ASSAULTRIFLE`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_ASSAULTRIFLE_MK2`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_COMBATMG`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_COMBATMG_MK2`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_HEAVYSNIPER`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_HEAVYSNIPER_MK2`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MARKSMANRIFLE`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MARKSMANRIFLE_MK2`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MG`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MINIGUN`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MUSKET`] = WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_RAILGUN`] = WeaponClasses['HIGH_CALIBER'],

    --[[ Shotguns ]]--
    [`WEAPON_ASSAULTSHOTGUN`] = WeaponClasses['SHOTGUN'],
    [`WEAPON_BULLUPSHOTGUN`] = WeaponClasses['SHOTGUN'],
    [`WEAPON_DBSHOTGUN`] = WeaponClasses['SHOTGUN'],
    [`WEAPON_HEAVYSHOTGUN`] = WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN`] = WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN_MK2`] = WeaponClasses['SHOTGUN'],
    [`WEAPON_SAWNOFFSHOTGUN`] = WeaponClasses['SHOTGUN'],
    [`WEAPON_SWEEPERSHOTGUN`] = WeaponClasses['SHOTGUN'],

    --[[ Animals ]]--
    [`WEAPON_ANIMAL`] = WeaponClasses['WILDLIFE'], -- Animal
    [`WEAPON_COUGAR`] = WeaponClasses['WILDLIFE'], -- Cougar
    [`WEAPON_BARBED_WIRE`] = WeaponClasses['WILDLIFE'], -- Barbed Wire
    
    --[[ Cutting Weapons ]]--
    [`WEAPON_BATTLEAXE`] = WeaponClasses['CUTTING'],
    [`WEAPON_BOTTLE`] = WeaponClasses['CUTTING'],
    [`WEAPON_DAGGER`] = WeaponClasses['CUTTING'],
    [`WEAPON_HATCHET`] = WeaponClasses['CUTTING'],
    [`WEAPON_KNIFE`] = WeaponClasses['CUTTING'],
    [`WEAPON_MACHETE`] = WeaponClasses['CUTTING'],
    [`WEAPON_SWITCHBLADE`] = WeaponClasses['CUTTING'],

    --[[ Light Impact ]]--
    [`WEAPON_GARBAGEBAG`] = WeaponClasses['WILDLIFE'], -- Garbage Bag
    [`WEAPON_BRIEFCASE`] = WeaponClasses['WILDLIFE'], -- Briefcase
    [`WEAPON_BRIEFCASE_02`] = WeaponClasses['WILDLIFE'], -- Briefcase 2
    [`WEAPON_BALL`] = WeaponClasses['LIGHT_IMPACT'],
    [`WEAPON_FLASHLIGHT`] = WeaponClasses['LIGHT_IMPACT'],
    [`WEAPON_KNUCKLE`] = WeaponClasses['LIGHT_IMPACT'],
    [`WEAPON_NIGHTSTICK`] = WeaponClasses['LIGHT_IMPACT'],
    [`WEAPON_SNOWBALL`] = WeaponClasses['LIGHT_IMPACT'],
    [`WEAPON_UNARMED`] = WeaponClasses['LIGHT_IMPACT'],
    [`WEAPON_PARACHUTE`] = WeaponClasses['LIGHT_IMPACT'],
    [`WEAPON_NIGHTVISION`] = WeaponClasses['LIGHT_IMPACT'],
    
    --[[ Heavy Impact ]]--
    [`WEAPON_BAT`] = WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_CROWBAR`] = WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_FIREEXTINGUISHER`] = WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_FIRWORK`] = WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_GOLFLCUB`] = WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_HAMMER`] = WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_PETROLCAN`] = WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_POOLCUE`] = WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_WRENCH`] = WeaponClasses['HEAVY_IMPACT'],
    
    --[[ Explosives ]]--
    [`WEAPON_EXPLOSION`] = WeaponClasses['EXPLOSIVE'], -- Explosion
    [`WEAPON_GRENADE`] = WeaponClasses['EXPLOSIVE'],
    [`WEAPON_COMPACTLAUNCHER`] = WeaponClasses['EXPLOSIVE'],
    [`WEAPON_HOMINGLAUNCHER`] = WeaponClasses['EXPLOSIVE'],
    [`WEAPON_PIPEBOMB`] = WeaponClasses['EXPLOSIVE'],
    [`WEAPON_PROXMINE`] = WeaponClasses['EXPLOSIVE'],
    [`WEAPON_RPG`] = WeaponClasses['EXPLOSIVE'],
    [`WEAPON_STICKYBOMB`] = WeaponClasses['EXPLOSIVE'],
    
    --[[ Other ]]--
    [`WEAPON_FALL`] = WeaponClasses['FALL'], -- Fall
    [`WEAPON_HIT_BY_WATER_CANNON`] = WeaponClasses['OTHER'], -- Water Cannon
    [`WEAPON_RAMMED_BY_CAR`] = WeaponClasses['OTHER'], -- Rammed
    [`WEAPON_RUN_OVER_BY_CAR`] = WeaponClasses['OTHER'], -- Ran Over
    [`WEAPON_HELI_CRASH`] = WeaponClasses['OTHER'], -- Heli Crash
    [`WEAPON_STUNGUN`] = WeaponClasses['OTHER'],
    
    --[[ Fire ]]--
    [`WEAPON_ELECTRIC_FENCE`] = WeaponClasses['FIRE'], -- Electric Fence 
    [`WEAPON_FIRE`] = WeaponClasses['FIRE'], -- Fire
    [`WEAPON_MOLOTOV`] = WeaponClasses['FIRE'],
    [`WEAPON_FLARE`] = WeaponClasses['FIRE'],
    [`WEAPON_FLAREGUN`] = WeaponClasses['FIRE'],

    --[[ Suffocate ]]--
    [`WEAPON_DROWNING`] = WeaponClasses['SUFFOCATING'], -- Drowning
    [`WEAPON_DROWNING_IN_VEHICLE`] = WeaponClasses['SUFFOCATING'], -- Drowning Veh
    [`WEAPON_EXHAUSTION`] = WeaponClasses['SUFFOCATING'], -- Exhaust
    [`WEAPON_BZGAS`] = WeaponClasses['SUFFOCATING'],
    [`WEAPON_SMOKEGRENADE`] = WeaponClasses['SUFFOCATING'],
}