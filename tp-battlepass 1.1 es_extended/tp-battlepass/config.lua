Config = {}

Config.Locale      = "en"

-- ## [SCRIPTS SUPPORTED]: mythic_notify, okoknotify, pnotify, default
Config.NotificationScript     = "mythic_notify" 

Config.LevelUpCost = 10

Config.levelRewardPacks    = {
    ['clips'] = {
        rewards = {
            ['1'] = {name = "disc_ammo_pistol",  type = "item", amount = 5},
            ['2'] = {name = "disc_ammo_rifle",   type = "item", amount = 5},
            ['3'] = {name = "disc_ammo_smg",     type = "item", amount = 5},
        },
    },
    ['example1'] = {
        rewards = {
            ['1'] = {name = "",  type = "money", amount = 50},
            ['2'] = {name = "",  type = "black_money", amount = 500},
            ['3'] = {name = "",  type = "bank", amount = 5000},
        },
    },

    ['example2'] = {
        rewards = {
            ['1'] = {name = "WEAPON_PISTOL",  type = "weapon", amount = 0},
        },
    },
}

Config.LevelsConfiguration = {
    {
        level = 1,
        playedTimeRequired = 300,
        levelReward = {
            type = 'money',
            reward = 'CASH',
            amount = 50,
            title = 'CASH',
            description = '- $50 CASH',
            image = 'img/items/cash.png'
        } 
    },
    {
        level = 2,
        playedTimeRequired = 300,
        levelReward = {
            type = 'clips',
            reward = 'clips',
            amount = 1,
            title = 'CLIPS',
            description = '- 5x PISTOL, AR & SMG CLIPS',
            image = 'img/items/clip.png'
        } 
    },

    {
        level = 3,
        playedTimeRequired = 300,
        levelReward = {
            type = 'weapon',
            reward = 'WEAPON_COMBATPDW',
            amount = 1,
            title = 'UMP-45',
            description = '- “Who said personal weaponry couldnt be worthy of military personnel? Thanks to our lobbyists, not Congress. Integral suppressor.”',
            image = 'img/items/combatpdw.png'
        } 
    },


    {
        level = 4,
        playedTimeRequired = 300,
        levelReward = {
            type = 'weapon',
            reward = 'WEAPON_MICROSMG',
            amount = 1,
            title = 'UZI',
            description = '- “Combines compact design with a high rate of fire at approximately 700-900 rounds per minute.”',
            image = 'img/items/uzi.png'
        } 
    },

    {
        level = 5,
        playedTimeRequired = 300,
        levelReward = {
            type = 'item',
            reward = 'medikit',
            amount = 5,
            title = 'MEDICAL',
            description = '- 5x MEDICAL SUPPLEMENTS',
            image = 'img/items/medkit.png'
        } 
    },

    {
        level = 6,
        playedTimeRequired = 300,
        levelReward = {
            type = 'weapon',
            reward = 'WEAPON_PUMPSHOTGUN',
            amount = 1,
            title = 'PUMP SHOTGUN',
            description = '- “Standard shotgun ideal for short-range combat. A high-projectile spread makes up for its lower accuracy at long range.”',
            image = 'img/items/pumpshotgun.png'
        } 
    },

    {
        level = 7,
        playedTimeRequired = 300,
        levelReward = {
            type = 'weapon',
            reward = 'WEAPON_COMPACTRIFLE',
            amount = 50,
            title = 'COMPACT RIFLE',
            description = '- “Half the size, all the power, double the recoil: theres no riskier way to say Im compensating for something.”',
            image = 'img/items/compactrifle.png'
        } 
    },

    {
        level = 8,
        playedTimeRequired = 300,
        levelReward = {
            type = 'weapon',
            reward = 'WEAPON_REVOLVER',
            amount = 1,
            title = 'REVOLVER',
            description = "- “A handgun with enough stopping power to drop a crazed rhino, and heavy enough to beat it to death if youre out of ammo.”",
            image = 'img/items/revolver.png'
        } 
    },

    {
        level = 9,
        playedTimeRequired = 300,
        levelReward = {
            type = 'weapon',
            reward = 'WEAPON_ADVANCEDRIFLE',
            amount = 1,
            title = 'ADVANCED RIFLE',
            description = '- “The most lightweight and compact of all assault rifles, without compromising accuracy and rate of fire.”',
            image = 'img/items/advancedrifle.png'
        } 
    },
}