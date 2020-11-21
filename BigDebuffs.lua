
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
			target = "TargetPortrait",
			focus = "FocusPortrait",
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
		
		frame.cooldownContainer = CreateFrame("Button", frameName.."CooldownContainer", frame)
		frame.cooldownContainer:SetPoint("CENTER")
		
		frame.cooldown = _G[frameName.."Cooldown"]
		frame.cooldown:SetParent(frame.cooldownContainer)
		frame.cooldown:SetAllPoints()
		frame.cooldown:SetAlpha(0.9)
		frame.cooldown:SetReverse(true)
		
		
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
			frame.cooldownContainer:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel()-1)
			frame.cooldownContainer:SetHeight(frame.anchor:GetHeight()-9)
			frame.cooldownContainer:SetWidth(frame.anchor:GetWidth()-9)
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
		frame.cooldownContainer:SetHeight(frame:GetHeight())
		frame.cooldownContainer:SetWidth(frame:GetWidth())
		
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
	return GetSpellInfo(debuff[1]), nil, debuff[2], 0, "Magic", 50, 50, nil
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
		local pack = {self, guid}
		self.interrupts[guid].timer = BigDebuffs:ScheduleTimer(self.ClearInterruptGUID, 30, pack)
	end
	self.interrupts[guid].failed = GetTime()
end

function BigDebuffs:COMBAT_LOG_EVENT_UNFILTERED(_, ...)
	local _, subEvent, sourceGUID, _, _, destGUID, destName, _, spellid, name = ...

	if subEvent == "SPELL_CAST_SUCCESS" and self.Spells[spellid] then
		if spellid == 2457 or spellid == 2458 or spellid == 71 then -- stances
			self:UpdateStance(sourceGUID, spellid)
		end
	end

	if subEvent ~= "SPELL_CAST_SUCCESS" and subEvent ~= "SPELL_INTERRUPT" then
		return
	end
		
	-- UnitChannelingInfo and event orders are not the same in earlier expansions as later expansions, UnitChannelingInfo 
	-- will always return nil @ the time of this event (independent of whether something was kicked or not).
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
		guid, self = self[2], self[1]
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
		unit, guid, spellid, self = self[2], self[3], self[4], self[1]
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
		guid, self = self[2], self[1]
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
	local left, priority, duration, icon, isAura, interrupt = 0, 0
	
	for i = 1, 40 do
		-- Check debuffs
		local n, _, ico, _, _, d, l = UnitDebuff(unit, i)

		if n then
			if self.Spells[n] then
				local p = self:GetAuraPriority(n)
				if p and (p > priority or (p == prio and left and l and l < left)) then
					left = l
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
		local n, _, ico, _, d, l = UnitBuff(unit, i)
		
		if n then
			if self.Spells[n] then
				local p = self:GetAuraPriority(n)
				if p and (p > priority or (p == prio and left and l and l < left)) then
					left = l
					duration = d
					isAura = true
					priority = p
					icon = ico
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
		if p and (p > priority or (p == prio and left and e and e-now < left)) then
			left = e - now
			duration = d
			isAura = true
			priority = p
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
				duration = nil
				isAura = true
				priority = p
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
		
		if duration and duration >= 1 then
			frame.cooldown:SetCooldown(now+left-duration, duration)
			frame.cooldownContainer:Show()
		else 
			frame.cooldown:SetCooldown(0, 0)
			frame.cooldownContainer:Hide()
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
