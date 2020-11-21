
-- BigDebuffs by Jordon 
-- Backported and general improvements by Konjunktur
-- Spell list and minor improvements by Apparent

BigDebuffs = LibStub("AceAddon-3.0"):NewAddon("BigDebuffs", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

-- Defaults
local defaults = {
	profile = {
		unitFrames = {
			enabled = true,
			cooldownCount = true,
			player = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			focus = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			target = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			pet = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			party = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			cc = true,
			interrupts = true,
			immunities = true,
			immunities_spells = true,
			buffs_defensive = true,
			buffs_offensive = true,
			buffs_other = true,
			roots = true,
		},
		priority = {
			immunities = 90,
			immunities_spells = 80,
			cc = 70,
			interrupts = 60,
			buffs_defensive = 50,
			buffs_offensive = 40,
			buffs_other = 30,
			roots = 20,
		},
		spells = {},
	}
}

--[[
BigDebuffs.Spells = {
	-- Death Knight
	[48792] = { type = "buffs_defensive", },  -- Icebound Fortitude
	[50461] = { type = "buffs_defensive", },  -- Anti-Magic Zone
	[47484] = { type = "buffs_defensive", }, -- Huddle (Ghoul)
	[49028] = { type = "buffs_offensive", },  -- Dancing Rune Weapon // might not work - spell id vs aura
	[47476] = { type = "cc", },  -- Strangulate
	[47481] = { type = "cc", },  -- Gnaw
	[49203] = { type = "cc", }, -- Hungering Cold
	[48707] = { type = "immunities_spells", },  -- Anti-Magic Shell
	[49039] = { type = "immunities_spells", },  -- Lichborne
	[53550] = { type = "interrupts", interruptduration = 4, },  -- Mind Freeze
	-- Druid
	[22842] = { type = "buffs_defensive", },  -- Frenzied Regeneration
	[17116] = { type = "buffs_defensive", }, -- Nature's Swiftness
	[61336] = { type = "buffs_defensive", },  -- Survival Instincts
	[22812] = { type = "buffs_defensive", },  -- Barkskin
	[29166] = { type = "buffs_offensive", },  -- Innervate
	[50334] = { type = "buffs_offensive", },  -- Berserk
	[69369] = { type = "buffs_offensive", }, -- Predator's Swiftness
	[53201] = { type = "buffs_offensive", }, -- Starfall
	[53312] = { type = "buffs_other", }, -- Nature's Grasp
	[33357] = { type = "buffs_other", },  -- Dash
	[768] = { type = "buffs_other", }, -- Cat Form
	[9634] = { type = "buffs_other", }, -- Dire Bear Form
	[783] = { type = "buffs_other", }, -- Travel Form
	[24858] = { type = "buffs_other", }, -- Moonkin Form
	[33891] = { type = "buffs_other", }, -- Tree of Life
	[49802] = { type = "cc" },  -- Maim
	[8983] = { type = "cc", },  -- Bash
	[18658] = {type = "cc"}, -- Hibernate
		[2637] = {type = "cc"},
		[18657] = {type = "cc"},
	[49803] = { type = "cc", },  -- Pounce
	[33786] = { type = "immunities" },  -- Cyclone
	[45334] = { type = "roots", },  -- Feral Charge Effect (Immobilize)
	[53308] = { type = "roots", },  -- Entangling Roots
	[53313] = { type = "roots", }, -- Entangling Roots (From Nature's Grasp)
	[19675] = { type = "interrupts", interruptduration = 4, },  -- Feral Charge Effect (Interrupt)
	-- Hunter
	[3045] = { type = "buffs_offensive", }, -- Rapid Fire
	[53480] = { type = "buffs_defensive", },  -- Roar of Sacrifice (Hunter Pet Skill)
	[5384] = { type = "buffs_defensive", },  -- Feign Death
	[53271] = { type = "buffs_defensive", },  -- Master's Call
	[53476] = { type = "buffs_defensive", }, -- Intervene (Pet)
	[1742] = { type = "buffs_defensive", }, -- Cower (Pet)
	[26064] = { type = "buffs_defensive", }, -- Shell Shield (Pet)
	[34471] = { type = "immunities", },  -- The Beast Within
	[19263] = { type = "immunities", },  -- Deterrence
	[19574] = { type = "immunities", }, -- Bestial Wrath (Pet)
	[3034] = { type = "buffs_other", },  -- Viper Sting
	[24394] = { type = "cc", },  -- Intimidation (Stun)
		[19577] = { type = "buffs_offensive", }, -- Intimidation (Pet Buff)
	[49012] = { type = "cc", },  -- Wyvern Sting
	[19503] = { type = "cc", },  -- Scatter Shot
	[14309] = { type = "cc", },  -- Freezing Trap
	[60210] = { type = "cc", }, -- Freezing Arrow Effect
	[14327] = { type = "cc", }, -- Scare Beast
	[53359] = { type = "cc", }, -- Chimera Shot - Scorpid (Disarm)
	[53562] = { type = "cc", }, -- Ravage (Pet)
	[53543] = { type = "cc", }, -- Snatch (Pet Disarm)
	[34490] = { type = "cc", }, -- Silencing Shot
	[48999] = { type = "roots", }, -- Counterattack
	[19185] = { type = "roots", }, -- Entrapment
		[64803] = { type = "roots", },
		[64804] = { type = "roots", },
	[53548] = { type = "roots", }, -- Pin (Pet)
	[4167] = { type = "roots", }, -- Web (Pet)
	[26090] = { type = "interrupts", interruptduration = 2, }, -- Pummel (Pet)
	-- Mage
	[43039] = { type = "buffs_other", },  -- Ice Barrier
	[12472] = { type = "buffs_offensive", },  -- Icy Veins
	[54748] = { type = "buffs_offensive", }, -- Burning Determination (Interrupt/Silence Immunity)
	[12042] = { type = "buffs_offensive", },  -- Arcane Power
	[12043] = { type = "buffs_offensive", },  -- Presence of Mind
	[12051] = { type = "buffs_offensive", },  -- Evocation
	[44544] = { type = "buffs_offensive", }, -- Fingers of Frost
	[66] = { type = "buffs_offensive", },  -- Invisibility
	[118] = { type = "cc", },  -- Polymorph
		[12826] = { type = "cc", },
		[71319] = { type = "cc", },
		[28271] = { type = "cc", },
		[28272] = { type = "cc", },
		[61305] = { type = "cc", },
		[61721] = { type = "cc", },
	[42950] = { type = "cc", },  -- Dragon's Breath
	[44572] = { type = "cc", }, -- Deep Freeze
	[12355] = { type = "cc", }, -- Impact
	[55021] = { type = "cc", }, -- Improved Counterspell
	[64346] = { type = "cc", }, -- Fiery Payback (Fire Mage Disarm)
	[45438] = { type = "immunities", },  -- Ice Block
	[12494] = { type = "roots", },  -- Frostbite
	[42917] = { type = "roots", },  -- Frost Nova
	[2139] = { type = "interrupts", interruptduration = 6, },  -- Counterspell (Mage)
	-- Paladin
	[54428] = { type = "buffs_other", }, -- Divine Plea
	[58597] = { type = "buffs_other", }, -- Sacred Shield Proc
	[59578] = { type = "buffs_other", }, -- The Art of War
	[10278] = { type = "buffs_defensive", },  -- Hand of Protection
		[5599] = { type = "buffs_defensive", },
		[1022] = { type = "buffs_defensive", },
	[31852] = { type = "buffs_defensive", },  -- Ardent Defender
	[31821] = { type = "buffs_defensive", },  -- Aura Mastery
	[498] = { type = "buffs_defensive", },  -- Divine Protection
	[6940] = { type = "buffs_defensive", },  -- Hand of Sacrifice
	[1044] = { type = "buffs_defensive", },  -- Hand of Freedom
	[64205] = { type = "buffs_defensive", }, -- Divine Sacrifice
	[31884] = { type = "buffs_offensive", },  -- Avenging Wrath
	[20066] = { type = "cc", },  -- Repentance
	[10308] = { type = "cc", },  -- Hammer of Justice
	[63529] = { type = "cc", }, -- Silenced - Shield of the Templar
	[10326] = { type = "cc", }, -- Turn Evil
	[48817] = { type = "cc", }, -- Holy Wrath
	[20170] = { type = "cc", }, -- Seal of Justice Stun
	[642] = { type = "immunities", },  -- Divine Shield
	-- Priest
	[47585] = { type = "buffs_defensive", },  -- Dispersion
	[20711] = { type = "buffs_defensive", },  -- Spirit of Redemption
	[47788] = { type = "buffs_defensive", },  -- Guardian Spirit
	[14751] = { type = "buffs_defensive", },  -- Inner Focus
	[33206] = { type = "buffs_defensive", },  -- Pain Suppression
	[64843] = { type = "buffs_defensive", },  -- Divine Hymn
	[64901] = { type = "buffs_defensive", }, -- Hymn of Hope
	[10060] = { type = "buffs_offensive", },  -- Power Infusion
	[6346] = { type = "buffs_other", },  -- Fear Ward
	[48066] = { type = "buffs_other", }, -- Power Word: Shield
	[64044] = { type = "cc", }, -- Psychic Horror (Horrify)
	[64058] = { type = "cc", }, -- Psychic Horror (Disarm)
	[10890] = { type = "cc", },  -- Psychic Scream
	[15487] = { type = "cc", },  -- Silence
	[605] = { type = "cc", },  -- Mind Control
	[10955] = { type = "cc", },  -- Shackle Undead
	-- Rogue
	[51713] = { type = "buffs_offensive", }, -- Shadow Dance
	[13750] = { type = "buffs_offensive", },  -- Adrenaline Rush
	[51690] = { type = "buffs_offensive", },  -- Killing Spree
	[14177] = { type = "buffs_offensive", }, -- Cold Blood
	[11305] = { type = "buffs_other", },  -- Sprint
	[26669] = { type = "buffs_defensive", },  -- Evasion
	[11286] = { type = "cc", },  -- Gouge
	[51722] = {type = "cc", }, -- Dismantle
	[2094] = { type = "cc", },  -- Blind
	[8643] = { type = "cc", },  -- Kidney Shot
	[51724] = { type = "cc", },  -- Sap
	[1330] = { type = "cc", },  -- Garrote - Silence
	[1833] = { type = "cc", },  -- Cheap Shot
	[18425] = { type = "cc", }, -- Silence (Improved Kick)
	[31224] = { type = "immunities_spells", },  -- Cloak of Shadows
	[1766] = { type = "interrupts", interruptduration = 5, },  -- Kick
	-- Shaman
	[16166] = { type = "buffs_offensive", }, -- Elemental Mastery (Instant Cast)
	[2825] = { type = "buffs_offensive", },  -- Bloodlust
	[32182] = { type = "buffs_offensive", },  -- Heroism
	[16191] = { type = "buffs_offensive", }, -- Mana Tide Totem
	[30823] = { type = "buffs_defensive", }, -- Shamanistic Rage
	[16188] = { type = "buffs_defensive", }, -- Nature's Swiftness
	[58861] = { type = "cc", }, -- Bash (Spirit Wolf)
	[51514] = { type = "cc", },  -- Hex
	[39796] = { type = "cc", }, -- Stoneclaw Stun
	[8178] = { type = "immunities_spells", }, -- Grounding Totem Effect
	[63685] = { type = "roots", }, -- Freeze (Enhancement)
	[64695] = { type = "roots", }, -- Earthgrab (Elemental)
	[58875] = { type = "buffs_other", }, -- Spirit Walk (Spirit Wolf)
	[55277] = { type = "buffs_other", }, -- Stoneclaw Totem (Absorb)
	[57994] = { type = "interrupts", interruptduration = 2, },  -- Wind Shear
	-- Warlock
	[47241] = { type = "buffs_offensive", }, -- Metamorphosis
	[18708] = { type = "buffs_other", },  -- Fel Domination
	[47986] = { type = "buffs_other", }, -- Sacrifice
	[60995] = { type = "cc", }, -- Demon Charge (Metamorphosis)
	[47847] = { type = "cc", },  -- Shadowfury
		[30283] = { type = "cc", },
	[31117] = { type = "cc", },  -- Unstable Affliction (Silence)
	[18647] = { type = "cc", },  -- Banish
	[47860] = { type = "cc", },  -- Death Coil
	[6358] = { type = "cc", },  -- Seduction
	[6215] = { type = "cc", },  -- Fear
	[17928] = { type = "cc", },  -- Howl of Terror
	[24259] = { type = "cc", }, -- Spell Lock (Silence)
	[47995] = { type = "cc", }, -- Intercept (Felguard)
	[19647] = { type = "interrupts", interruptduration = 6, },  -- Spell Lock (Interrupt)
	-- Warrior
	[12975] = { type = "buffs_defensive", },  -- Last Stand
	[55694] = { type = "buffs_defensive", },  -- Enraged Regeneration
	[871] = { type = "buffs_defensive", },  -- Shield Wall
	[3411] = { type = "buffs_defensive", },  -- Intervene
	[2565] = { type = "buffs_defensive", }, -- Shield Block
	[20230] = { type = "buffs_defensive", }, -- Retaliation
	[60503] = { type = "buffs_offensive", }, -- Taste for Blood
	[64849] = { type = "buffs_offensive", }, -- Unrelenting Assault (1/2)
	[65925] = { type = "buffs_offensive", }, -- Unrelenting Assault (2/2)
	[1719] = { type = "buffs_offensive", },  -- Recklessness
	[12292] = { type = "buffs_offensive", }, -- Death Wish
	[18499] = { type = "buffs_other", },  -- Berserker Rage
	[2457] = { type = "buffs_other", }, -- Battle Stance
	[2458] = { type = "buffs_other", }, -- Berserker Stance
	[71] = { type = "buffs_other", }, -- Defensive Stance
	[12809] = { type = "cc", }, -- Concussion Blow
	[12798] = { type = "cc", }, -- Revenge Stun
	[676] = { type = "cc", },  -- Disarm
	[46968] = { type = "cc", },  -- Shockwave
	[5246] = { type = "cc", },  -- Intimidating Shout (Non - Target)
	[20511] = { type = "cc", }, -- Intimidating Shout (Target)
	[7922] = { type = "cc", }, -- Charge
	[20253] = { type = "cc", }, -- Intercept
	[18498] = { type = "cc", }, -- Silenced - Gag Order
	[46924] = { type = "immunities", },  -- Bladestorm
	[23920] = { type = "immunities_spells", },  -- Spell Reflection
	[6552] = { type = "interrupts", interruptduration = 4, },  -- Pummel
	[72] = { type = "interrupts", interruptduration = 5, }, -- Shield Bash
	-- Misc
	[43183] = { type = "buffs_other", },  -- Drink (Arena/Lvl 80 Water) -- Need to change to 70 water
		[57073] = { type = "buffs_other" }, -- (Mage Water) -- Need to change to 70 water
	[20549] = { type = "cc", },  -- War Stomp
	[28730] = { type = "cc", }, -- Arcane Torrent (Mana)
	[25046] = { type = "cc", }, -- Arcane Torrent (Energy)
	[50613] = { type = "cc", }, -- Arcane Torrent (Runic Power)
}
]]

BigDebuffs.Spells = {
	--Druid
	["Frenzied Regeneration"] = { type = "buffs_defensive", },
	["Nature's Swiftness"] = { type = "buffs_defensive", },
	["Survival Instincts"] = { type = "buffs_defensive", },
	["Barkskin"] = { type = "buffs_defensive", },
	["Innervate"] = { type = "buffs_offensive", },
	["Berserk"] = { type = "buffs_offensive", },
	["Predator's Swiftness"] = { type = "buffs_offensive", },
	["Starfall"] = { type = "buffs_offensive", },
	["Nature's Grasp"] = { type = "buffs_other", },
	["Dash"] = { type = "buffs_other", },
	["Cat Form"] = { type = "buffs_other", },
	["Dire Bear Form"] = { type = "buffs_other", },
	["Travel Form"] = { type = "buffs_other", },
	["Moonkin Form"] = { type = "buffs_other", },
	["Tree of Life"] = { type = "buffs_other", },
	["Maim"] = { type = "cc" },
	["Bash"] = { type = "cc", },
	["Pounce"] = { type = "cc", },
	["Cyclone"] = { type = "immunities" },
	["Feral Charge Effect (Immobilize)"] = { type = "roots", },
	["Entangling Roots"] = { type = "roots", },
	["Feral Charge Effect (Interrupt)"] = { type = "interrupts", interruptduration = 4, },
	-- Hunter
	["Rapid Fire"] = { type = "buffs_offensive", },
	["Roar of Sacrifice"] = { type = "buffs_defensive", },
	["Feign Death"] = { type = "buffs_defensive", },
	["Master's Call"] = { type = "buffs_defensive", },
	["Intervene"] = { type = "buffs_defensive", },
	["Cower"] = { type = "buffs_defensive", },
	["Shell Shield"] = { type = "buffs_defensive", },
	["The Beast Within"] = { type = "immunities", },
	["Deterrence"] = { type = "immunities", },
	["Bestial Wrath"] = { type = "immunities", },
	["Viper Sting"] = { type = "buffs_other", },
	["Intimidation"] = { type = "cc", },
	["Wyvern Sting"] = { type = "cc", },
	["Scatter Shot"] = { type = "cc", },
	["Freezing Trap"] = { type = "cc", },
	["Freezing Arrow Effect"] = { type = "cc", },
	["Scare Beast"] = { type = "cc", },
	["Chimera Shot - Scorpid (Disarm)"] = { type = "cc", },
	["Ravage (Pet)"] = { type = "cc", },
	["Snatch (Pet Disarm)"] = { type = "cc", },
	["Silencing Shot"] = { type = "cc", },
	["Counterattack"] = { type = "roots", },
	["Entrapment"] = { type = "roots", },
	["Pin (Pet)"] = { type = "roots", },
	["Web (Pet)"] = { type = "roots", },
	["Pummel (Pet)"] = { type = "interrupts", interruptduration = 2, },
	-- Mage
	["Ice Barrier"] = { type = "buffs_other", },
	["Icy Veins"] = { type = "buffs_offensive", },
	["Burning Determination (Interrupt/Silence Immunity)"] = { type = "buffs_offensive", },
	["Arcane Power"] = { type = "buffs_offensive", },
	["Presence of Mind"] = { type = "buffs_offensive", },
	["Evocation"] = { type = "buffs_offensive", },
	["Fingers of Frost"] = { type = "buffs_offensive", },
	["Invisibility"] = { type = "buffs_offensive", },
	["Polymorph"] = { type = "cc", },
	["Dragon's Breath"] = { type = "cc", },
	["Deep Freeze"] = { type = "cc", },
	["Impact"] = { type = "cc", },
	["Improved Counterspell"] = { type = "cc", },
	["Fiery Payback (Fire Mage Disarm)"] = { type = "cc", },
	["Ice Block"] = { type = "immunities", },
	["Frostbite"] = { type = "roots", },
	["Frost Nova"] = { type = "roots", },
	["Counterspell (Mage)"] = { type = "interrupts", interruptduration = 6, },
	-- Paladin
	["Divine Plea"] = { type = "buffs_other", },
	["Sacred Shield Proc"] = { type = "buffs_other", },
	["The Art of War"] = { type = "buffs_other", },
	["Hand of Protection"] = { type = "buffs_defensive", },
	["Ardent Defender"] = { type = "buffs_defensive", },
	["Aura Mastery"] = { type = "buffs_defensive", },
	["Divine Protection"] = { type = "buffs_defensive", },
	["Hand of Sacrifice"] = { type = "buffs_defensive", },
	["Hand of Freedom"] = { type = "buffs_defensive", },
	["Divine Sacrifice"] = { type = "buffs_defensive", },
	["Avenging Wrath"] = { type = "buffs_offensive", },
	["Repentance"] = { type = "cc", },
	["Hammer of Justice"] = { type = "cc", },
	["Silenced - Shield of the Templar"] = { type = "cc", },
	["Turn Evil"] = { type = "cc", },
	["Holy Wrath"] = { type = "cc", },
	["Seal of Justice Stun"] = { type = "cc", },
	["Divine Shield"] = { type = "immunities", },
	-- Priest
	["Dispersion"] = { type = "buffs_defensive", },
	["Spirit of Redemption"] = { type = "buffs_defensive", },
	["Guardian Spirit"] = { type = "buffs_defensive", },
	["Inner Focus"] = { type = "buffs_defensive", },
	["Pain Suppression"] = { type = "buffs_defensive", },
	["Divine Hymn"] = { type = "buffs_defensive", },
	["Hymn of Hope"] = { type = "buffs_defensive", },
	["Power Infusion"] = { type = "buffs_offensive", },
	["Fear Ward"] = { type = "buffs_other", },
	["Power Word: Shield"] = { type = "buffs_other", },
	["Psychic Horror (Horrify)"] = { type = "cc", },
	["Psychic Horror (Disarm)"] = { type = "cc", },
	["Psychic Scream"] = { type = "cc", },
	["Silence"] = { type = "cc", },
	["Mind Control"] = { type = "cc", },
	["Shackle Undead"] = { type = "cc", },
	-- Rogue
	["Shadow Dance"] = { type = "buffs_offensive", },
	["Adrenaline Rush"] = { type = "buffs_offensive", },
	["Killing Spree"] = { type = "buffs_offensive", },
	["Cold Blood"] = { type = "buffs_offensive", },
	["Sprint"] = { type = "buffs_other", },
	["Evasion"] = { type = "buffs_defensive", },
	["Gouge"] = { type = "cc", },
	["Dismantle"] = {type = "cc", },
	["Blind"] = { type = "cc", },
	["Kidney Shot"] = { type = "cc", },
	["Sap"] = { type = "cc", },
	["Garrote - Silence"] = { type = "cc", },
	["Cheap Shot"] = { type = "cc", },
	["Silence (Improved Kick)"] = { type = "cc", },
	["Cloak of Shadows"] = { type = "immunities_spells", },
	["Kick"] = { type = "interrupts", interruptduration = 5, },
	-- Shaman
	["Elemental Mastery (Instant Cast)"] = { type = "buffs_offensive", },
	["Bloodlust"] = { type = "buffs_offensive", },
	["Heroism"] = { type = "buffs_offensive", },
	["Mana Tide Totem"] = { type = "buffs_offensive", },
	["Shamanistic Rage"] = { type = "buffs_defensive", },
	["Nature's Swiftness"] = { type = "buffs_defensive", },
	["Hex"] = { type = "cc", },
	["Stoneclaw Stun"] = { type = "cc", },
	["Grounding Totem Effect"] = { type = "immunities_spells", },
	["Freeze (Enhancement)"] = { type = "roots", },
	["Earthgrab (Elemental)"] = { type = "roots", },
	["Spirit Walk (Spirit Wolf)"] = { type = "buffs_other", },
	["Stoneclaw Totem (Absorb)"] = { type = "buffs_other", },
	["Wind Shear"] = { type = "interrupts", interruptduration = 2, },
	-- Warlock
	["Metamorphosis"] = { type = "buffs_offensive", },
	["Fel Domination"] = { type = "buffs_other", },
	["Sacrifice"] = { type = "buffs_other", },
	["Demon Charge (Metamorphosis)"] = { type = "cc", },
	["Shadowfury"] = { type = "cc", },
	["Unstable Affliction (Silence)"] = { type = "cc", },
	["Banish"] = { type = "cc", },
	["Death Coil"] = { type = "cc", },
	["Seduction"] = { type = "cc", },
	["Fear"] = { type = "cc", },
	["Howl of Terror"] = { type = "cc", },
	["Intercept"] = { type = "cc", },
	["Spell Lock"] = { type = "interrupts", interruptduration = 6, },
	-- Warrior
	["Last Stand"] = { type = "buffs_defensive", },
	["Enraged Regeneration"] = { type = "buffs_defensive", },
	["Shield Wall"] = { type = "buffs_defensive", },
	["Intervene"] = { type = "buffs_defensive", },
	["Shield Block"] = { type = "buffs_defensive", },
	["Retaliation"] = { type = "buffs_defensive", },
	["Taste for Blood"] = { type = "buffs_offensive", },
	["Unrelenting Assault"] = { type = "buffs_offensive", },
	["Recklessness"] = { type = "buffs_offensive", },
	["Death Wish"] = { type = "buffs_offensive", },
	["Berserker Rage"] = { type = "buffs_other", },
	["Battle Stance"] = { type = "buffs_other", },
	["Berserker Stance"] = { type = "buffs_other", },
	["Defensive Stance"] = { type = "buffs_other", },
	["Concussion Blow"] = { type = "cc", },
	["Revenge Stun"] = { type = "cc", },
	["Disarm"] = { type = "cc", },
	["Shockwave"] = { type = "cc", },
	["Intimidating Shout (Non - Target)"] = { type = "cc", },
	["Intimidating Shout (Target)"] = { type = "cc", },
	["Charge"] = { type = "cc", },
	["Intercept"] = { type = "cc", },
	["Silenced - Gag Order"] = { type = "cc", },
	["Bladestorm"] = { type = "immunities", },
	["Spell Reflection"] = { type = "immunities_spells", },
	["Pummel"] = { type = "interrupts", interruptduration = 4, },
	["Shield Bash"] = { type = "interrupts", interruptduration = 5, },
	-- Misc
	["Drink"] = { type = "buffs_other", },
	["War Stomp"] = { type = "cc", },
	["Arcane Torrent"] = { type = "cc", },
}

local units = {
	"player",
	"pet",
	"target",
	"focus",
	"party1",
	"party2",
	"party3",
	"party4",
}

local UnitDebuff, UnitBuff = UnitDebuff, UnitBuff

local GetAnchor = {
	ShadowedUnitFrames = function(anchor)
		local frame = _G[anchor]
		if not frame then return end
		if frame.portrait and frame.portrait:IsShown() then
			return frame.portrait, frame
		else
			return frame, frame, true
		end
	end,
	ZPerl = function(anchor)
		local frame = _G[anchor]
		if not frame then return end
		if frame:IsShown() then
			return frame, frame
		else
			frame = frame:GetParent()
			return frame, frame, true
		end
	end,
}

local anchors = {
	["ElvUI"] = {
		noPortrait = true,
		units = {
			player = "ElvUF_Player",
			pet = "ElvUF_Pet",
			target = "ElvUF_Target",
			focus = "ElvUF_Focus",
			party1 = "ElvUF_PartyGroup1UnitButton1",
			party2 = "ElvUF_PartyGroup1UnitButton2",
			party3 = "ElvUF_PartyGroup1UnitButton3",
			party4 = "ElvUF_PartyGroup1UnitButton4",
		},
	},
	["bUnitFrames"] = {
		noPortrait = true,
		alignLeft = true,
		units = {
			player = "bplayerUnitFrame",
			pet = "bpetUnitFrame",
			target = "btargetUnitFrame",
			focus = "bfocusUnitFrame",
		},
	},
	["Shadowed Unit Frames"] = {
		func = GetAnchor.ShadowedUnitFrames,
		units = {
			player = "SUFUnitplayer",
			pet = "SUFUnitpet",
			target = "SUFUnittarget",
			focus = "SUFUnitfocus",
			party1 = "SUFHeaderpartyUnitButton1",
			party2 = "SUFHeaderpartyUnitButton2",
			party3 = "SUFHeaderpartyUnitButton3",
			party4 = "SUFHeaderpartyUnitButton4",
		},
	},
	["ZPerl"] = {
		func = GetAnchor.ZPerl,
		units = {
			player = "XPerl_PlayerportraitFrame",
			pet = "XPerl_Player_PetportraitFrame",
			target = "XPerl_TargetportraitFrame",
			focus = "XPerl_FocusportraitFrame",
			party1 = "XPerl_party1portraitFrame",
			party2 = "XPerl_party2portraitFrame",
			party3 = "XPerl_party3portraitFrame",
			party4 = "XPerl_party4portraitFrame",
		},
	},
	["Blizzard"] = {
		units = {
			player = "PlayerPortrait",
			pet = "PetPortrait",
			target = "TargetFramePortrait",
			focus = "FocusFramePortrait",
			party1 = "PartyMemberFrame1Portrait",
			party2 = "PartyMemberFrame2Portrait",
			party3 = "PartyMemberFrame3Portrait",
			party4 = "PartyMemberFrame4Portrait",
		},
	},
}

function BigDebuffs:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BigDebuffsDB", defaults, "Default")

	self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
	self.frames = {}
	self.UnitFrames = {}
	
	self:SetupOptions()
end

local function HideBigDebuffs(frame)
	if not frame.BigDebuffs then return end
	for i = 1, #frame.BigDebuffs do
		frame.BigDebuffs[i]:Hide()
	end
end

function BigDebuffs:Refresh()
	for unit, frame in pairs(self.UnitFrames) do
		frame:Hide()
		frame.current = nil
		frame.cooldown.noCooldownCount = not self.db.profile.unitFrames.cooldownCount
		self:UNIT_AURA(nil, unit)
	end
end

function BigDebuffs:AttachUnitFrame(unit)
	if InCombatLockdown() then return end

	local frame = self.UnitFrames[unit]
	local frameName = "BigDebuffs" .. unit .. "UnitFrame"

	if not frame then
		frame = CreateFrame("Button", frameName, UIParent, "BigDebuffsUnitFrameTemplate")
		self.UnitFrames[unit] = frame

		frame.icon = _G[frameName.."Icon"]
		frame.icon:SetDrawLayer("BORDER")
		
		frame.cooldown = _G[frameName.."Cooldown"]
		frame.cooldown:SetParent(frame)
		frame.cooldown:SetAllPoints(frame)
		frame.cooldown:SetAlpha(0.9)
		
		frame:RegisterForDrag("LeftButton")
		frame:SetMovable(true)
		frame.unit = unit
	end

	frame:EnableMouse(self.test)

	_G[frameName.."Name"]:SetText(self.test and not frame.anchor and unit)

	frame.anchor = nil
	frame.blizzard = nil

	local config = self.db.profile.unitFrames[unit:gsub("%d", "")]

	if config.anchor == "auto" then
		-- Find a frame to attach to
		for k,v in pairs(anchors) do
			local anchor, parent, noPortrait
			if v.units[unit] then
				if v.func then
					anchor, parent, noPortrait = v.func(v.units[unit])
				else
					anchor = _G[v.units[unit]]
				end

				if anchor then
					frame.anchor, frame.parent, frame.noPortrait = anchor, parent, noPortrait
					if v.noPortrait then frame.noPortrait = true end
					frame.alignLeft = v.alignLeft
					frame.blizzard = k == "Blizzard"
					if not frame.blizzard then break end
				end
			end		
		end
	end

	if frame.anchor then
		if frame.blizzard then
			-- Blizzard Frame
			frame:SetParent(frame.anchor:GetParent())
			frame:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel())
			frame.cooldown:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel()-1)
			frame.cooldown:SetHeight(frame.anchor:GetHeight()-9)
			frame.cooldown:SetWidth(frame.anchor:GetWidth()-9)
			frame.anchor:SetDrawLayer("BACKGROUND")
		else
			frame:SetParent(frame.parent and frame.parent or frame.anchor)
			frame:SetFrameLevel(99)
			frame.cooldownContainer:SetHeight(frame.anchor:GetHeight())
			frame.cooldownContainer:SetWidth(frame.anchor:GetWidth())
		end

		frame:ClearAllPoints()

		if frame.noPortrait then
			-- No portrait, so attach to the side
			if frame.alignLeft then
				frame:SetPoint("TOPRIGHT", frame.anchor, "TOPLEFT")
			else
				frame:SetPoint("TOPLEFT", frame.anchor, "TOPRIGHT")
			end
			local height = frame.anchor:GetHeight()
			frame:SetHeight(height)
			frame:SetWidth(height)
		else
			frame:SetAllPoints(frame.anchor)
		end
	else
		-- Manual
		frame:SetParent(UIParent)
		frame:ClearAllPoints()
		frame.cooldown:SetHeight(frame:GetHeight())
		frame.cooldown:SetWidth(frame:GetWidth())
		
		if not self.db.profile.unitFrames[unit:gsub("%d", "")] then self.db.profile.unitFrames[unit:gsub("%d", "")] = {} end

		if self.db.profile.unitFrames[unit:gsub("%d", "")].position then
			frame:SetPoint(unpack(self.db.profile.unitFrames[unit:gsub("%d", "")].position))
		else
			-- No saved position, anchor to the blizzard position
			local relativeFrame = _G[anchors.Blizzard.units[unit]] or UIParent
			frame:SetPoint("CENTER", relativeFrame, "CENTER")
		end
		
		frame:SetHeight(config.size)
		frame:SetWidth(config.size)
	end

end

function BigDebuffs:SaveUnitFramePosition(frame)
	self.db.profile.unitFrames[frame.unit].position = { frame:GetPoint() }
end

function BigDebuffs:Test()
	self.test = not self.test
	self:Refresh()
end

local TestDebuffs = {}

function BigDebuffs:InsertTestDebuff(spellID)
	local texture = select(3, GetSpellInfo(spellID))
	table.insert(TestDebuffs, {spellID, texture})
end

local function UnitDebuffTest(unit, index)
	local debuff = TestDebuffs[index]
	if not debuff then return end
	return GetSpellInfo(debuff[1]), nil, debuff[2], 0, "Magic", 50, GetTime()+50, nil, nil, nil, debuff[1]
end

function BigDebuffs:OnEnable()
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self.interrupts = {}
	self.stances = {}

	-- Prevent OmniCC finish animations
	if OmniCC then
		self:RawHook(OmniCC, "TriggerEffect", function(object, cooldown)
			local name = cooldown:GetName()
			if name and name:find("BigDebuffs") then return end
			self.hooks[OmniCC].TriggerEffect(object, cooldown)
		end, true)
	end

	self:InsertTestDebuff(tostring(12472)) 	-- Icy Veins
end

function BigDebuffs:PLAYER_ENTERING_WORLD()
	for i = 1, #units do
		self:AttachUnitFrame(units[i])
	end
end

-- For unit frames
function BigDebuffs:GetAuraPriority(name, id)
	print("Checking Prio")
	if not self.Spells[id] and not self.Spells[name] then return end
	
	id = self.Spells[id] and id or name

	-- Make sure category is enabled
	if not self.db.profile.unitFrames[self.Spells[id].type] then return end

	-- Check for user set
	if self.db.profile.spells[id] then
		if self.db.profile.spells[id].unitFrames and self.db.profile.spells[id].unitFrames == 0 then return end
		if self.db.profile.spells[id].priority then return self.db.profile.spells[id].priority end
	end

	if self.Spells[id].nounitFrames and (not self.db.profile.spells[id] or not self.db.profile.spells[id].unitFrames) then
		return
	end

	return self.db.profile.priority[self.Spells[id].type] or 0
end

function BigDebuffs:GetUnitFromGUID(guid)
	for _,unit in pairs(units) do
		if UnitGUID(unit) == guid then
			return unit
		end
	end
	return nil
end

function BigDebuffs:UNIT_SPELLCAST_FAILED(_,unit, _, _, spellid)
	local guid = UnitGUID(unit)
	if self.interrupts[guid] == nil then
		self.interrupts[guid] = {}
		BigDebuffs:CancelTimer(self.interrupts[guid].timer)
		self.interrupts[guid].timer = BigDebuffs:ScheduleTimer(self.ClearInterruptGUID, 30, self, guid)
	end
	self.interrupts[guid].failed = GetTime()
end

function BigDebuffs:COMBAT_LOG_EVENT_UNFILTERED(_, ...)
	local _, subEvent, sourceGUID, _, _, destGUID, destName, _, spellid, name = ...

	if subEvent == "SPELL_CAST_SUCCESS" and self.Spells[spellid] then
		if spellid == 2457 or spellid == 2458 or spellid == 71 then
			self:UpdateStance(sourceGUID, spellid)
		end
	end

	if subEvent ~= "SPELL_CAST_SUCCESS" and subEvent ~= "SPELL_INTERRUPT" then
		return
	end
		
	-- UnitChannelingInfo and event orders are not the same in WotLK as later expansions, UnitChannelingInfo will always return
	-- nil @ the time of this event (independent of whether something was kicked or not).
	-- We have to track UNIT_SPELLCAST_FAILED for spell failure of the target at the (approx.) same time as we interrupted
	-- this "could" be wrong if the interrupt misses with a <0.01 sec failure window (which depending on server tickrate might
	-- not even be possible)
	if subEvent == "SPELL_CAST_SUCCESS" and not (self.interrupts[destGUID] and 
			self.interrupts[destGUID].failed and GetTime() - self.interrupts[destGUID].failed < 0.01) then
		return
	end
	
	local spelldata = self.Spells[name] and self.Spells[name] or self.Spells[spellid]
	if spelldata == nil or spelldata.type ~= "interrupts" then return end
	local duration = spelldata.interruptduration
   	if not duration then return end
	
	self:UpdateInterrupt(nil, destGUID, spellid, duration)
end

function BigDebuffs:UpdateStance(guid, spellid)
	if self.stances[guid] == nil then
		self.stances[guid] = {}
	else
		BigDebuffs:CancelTimer(self.stances[guid].timer)
	end
	
	self.stances[guid].stance = spellid
	local pack = {self, guid}
	self.stances[guid].timer = BigDebuffs:ScheduleTimer(self.ClearStanceGUID, 180, pack)

	local unit = self:GetUnitFromGUID(guid)
	if unit then
		self:UNIT_AURA(nil, unit)
	end
end

function BigDebuffs:ClearStanceGUID(guid)
	if self ~= BigDebuffs then
		self, guid = pack[1], pack[2]
	end
	
	local unit = self:GetUnitFromGUID(guid)
	if unit == nil then
		self.stances[guid] = nil
	else
		local pack = {self, guid}
		self.stances[guid].timer = BigDebuffs:ScheduleTimer(self.ClearStanceGUID, 180, pack)
	end
end

function BigDebuffs:UpdateInterrupt(unit, guid, spellid, duration)
	if self ~= BigDebuffs then
		self, unit, guid, spellid = pack[1], pack[2], pack[3], pack[4]
	end
	
	local t = GetTime()
	-- new interrupt
	if spellid and duration ~= nil then
		if self.interrupts[guid] == nil then self.interrupts[guid] = {} end
		BigDebuffs:CancelTimer(self.interrupts[guid].timer)
		local pack = {self, guid}
		self.interrupts[guid].timer = BigDebuffs:ScheduleTimer(self.ClearInterruptGUID, 30, pack)
		self.interrupts[guid][spellid] = {started = t, duration = duration}
	-- old interrupt expiring
	elseif spellid and duration == nil then
		if self.interrupts[guid] and self.interrupts[guid][spellid] and
				t > self.interrupts[guid][spellid].started + self.interrupts[guid][spellid].duration then
			self.interrupts[guid][spellid] = nil
		end
	end
	
	if unit == nil then
		unit = self:GetUnitFromGUID(guid)
	end
	
	if unit then	
		self:UNIT_AURA(nil, unit)
	end
	-- clears the interrupt after end of duration
	if duration then
		local pack = {self, unit, guid, spellid}
		BigDebuffs:ScheduleTimer(self.UpdateInterrupt, duration+0.1, pack)
	end
end

function BigDebuffs:ClearInterruptGUID(guid)
	if self ~= BigDebuffs then
		self, guid = pack[1], pack[2]
	end

	self.interrupts[guid] = nil
end

function BigDebuffs:GetInterruptFor(unit)
	local guid = UnitGUID(unit)
	interrupts = self.interrupts[guid]
	if interrupts == nil then return end
	
	local name, spellid, icon, duration, endsAt
	
	-- iterate over all interrupt spellids to find the one of highest duration
	for ispellid, intdata in pairs(interrupts) do
		if type(ispellid) == "number" then
			local tmpstartedAt = intdata.started
			local dur = intdata.duration
			local tmpendsAt = tmpstartedAt + dur
			if GetTime() > tmpendsAt then
				self.interrupts[guid][ispellid] = nil
			elseif endsAt == nil or tmpendsAt > endsAt then
				endsAt = tmpendsAt
				duration = dur
				name, _, icon = GetSpellInfo(ispellid)
				spellid = ispellid
			end
		end
	end
	
	if name then
		return name, spellid, icon, duration, endsAt
	end
end

function BigDebuffs:UNIT_AURA(event, unit)
	if not self.db.profile.unitFrames[unit:gsub("%d", "")] or 
			not self.db.profile.unitFrames[unit:gsub("%d", "")].enabled then 
		return 
	end
	self:AttachUnitFrame(unit)
	
	local frame = self.UnitFrames[unit]
	if not frame then return end
	
	local UnitDebuff = BigDebuffs.test and UnitDebuffTest or UnitDebuff
	
	local now = GetTime()
	local left, priority, duration, expires, icon, isAura, interrupt = 0, 0
	
	for i = 1, 40 do
		-- Check debuffs
		local n,_, ico, _,_, d, e = UnitDebuff(unit, i)
		if n then
			if self.Spells[n] then
				print("Spell in list")
				local p = self:GetAuraPriority(n)
				if p and (p > priority or (p == prio and expires and e < expires)) then
					left = e - now
					duration = d
					isAura = true
					priority = p
					expires = e
					icon = ico
				end
			end
		else
			break
		end
	end
	
	for i = 1, 40 do
		-- Check buffs
		local n,_, ico, _,_, d, e  = UnitBuff(unit, i)
		if n then
			if self.Spells[n] then
				local p = self:GetAuraPriority(n)
				if p and p >= priority then
					if p and (p > priority or (p == prio and expires and e < expires)) then
						left = e - now
						duration = d
						isAura = true
						priority = p
						expires = e
						icon = ico
					end
				end
			end
		else
			break
		end
	end
	
	-- check interrupts
	local n, id, ico, d, e = self:GetInterruptFor(unit)
	if n then
		local p = self:GetAuraPriority(n, id)
		if p and (p > priority or (p == prio and expires and e < expires)) then
			left = e - now
			duration = d
			isAura = true
			priority = p
			expires = e
			icon = ico
		end
	end

	-- check stances
	local guid = UnitGUID(unit)
	if self.stances[guid] then	
		local stanceId = self.stances[guid].stance
		if self.Spells[stanceId] then
			n, _, ico = GetSpellInfo(stanceId)
			local p = self:GetAuraPriority(n, stanceId)
			if p and p >= priority then
				left = 0
				duration = 0
				isAura = true
				priority = p
				expires = 0
				icon = ico
			end
		end
	end
	
	if isAura then
		if frame.current ~= icon then
			if frame.blizzard then
				-- Blizzard Frame
				SetPortraitToTexture(frame.icon, icon)
				-- Adapt
				if frame.anchor and Adapt and Adapt.portraits[frame.anchor] then
					Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("BACKGROUND")
				end
			else
				frame.icon:SetTexture(icon)
			end
		end
		
		if duration >= 1 then
			frame.cooldown:SetCooldown(expires - duration, duration)
			frame.cooldown:Show()
		else 
			frame.cooldown:SetCooldown(0, 0)
			frame.cooldown:Hide()
		end

		frame:Show()
		frame.current = icon
	else
		-- Adapt
		if frame.anchor and frame.blizzard and Adapt and Adapt.portraits[frame.anchor] then
			Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("LOW")
		else
			frame:Hide()
			frame.current = nil
		end
	end
end

function BigDebuffs:PLAYER_FOCUS_CHANGED()
	self:UNIT_AURA(nil, "focus")
end

function BigDebuffs:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA(nil, "target")
end

function BigDebuffs:UNIT_PET()
	self:UNIT_AURA(nil, "pet")
end

SLASH_BigDebuffs1 = "/bd"
SLASH_BigDebuffs2 = "/bigdebuffs"
SlashCmdList.BigDebuffs = function(msg)
	LibStub("AceConfigDialog-3.0"):Open("BigDebuffs")
end
