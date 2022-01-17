local Addon = select(1, ...)
local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Get the mode from a mode name
-- If modeName is nil, get the current mode
function SilentRotate:getMode(modeName)
    if not modeName then
        modeName = SilentRotate.db.profile.currentMode
    end

    if modeName and modeName:sub(-1) == 'z' then -- All old mode names end with 'z'
        modeName = SilentRotate.backwardCompatibilityModeMap[modeName] or modeName
    end

    -- return the mode object, or TranqShot as the default mode if no mode is set
    if modeName then
        local mode = SilentRotate.modes[modeName]
        if mode then -- mode may be nil when downgrading the addon version
            return mode
        end
    end
    return SilentRotate.modes[SilentRotate.modes.tranqShot.modeName]
end

-- Activate the specific mode
function SilentRotate:activateMode(modeName, mainFrame)
    local currentMode = self:getMode()
    local paramMode = self:getMode(modeName)
    if currentMode.modeName == paramMode.modeName then return end

    oldFrame = mainFrame.modeFrames[currentMode.modeName]
    if oldFrame then
        oldFrame.texture:SetColorTexture(SilentRotate.colors.darkBlue:GetRGB())
    end

    newFrame = mainFrame.modeFrames[modeName]
    if newFrame then
        SilentRotate.db.profile.currentMode = modeName
        newFrame.texture:SetColorTexture(SilentRotate.colors.blue:GetRGB())
        SilentRotate:updateRaidStatus()
        SilentRotate:enableRightClick(SilentRotate.modes[modeName] and SilentRotate.modes[modeName].assignable)
        local AceConfigDialog = LibStub("AceConfigDialog-3.0")
        AceConfigDialog:ConfigTableChanged("", Addon)
    end
end

-- Get the color associated to a specific mode
function SilentRotate:getModeColor(mode)
    if type(mode.color) == 'string' then
        return mode.color
    elseif type(mode.color) == 'function' then
        return mode.color()
    elseif type(mode.wanted) == 'string' then
        -- Assume a wingle string for mode.wanted is always the class name
        return select(4, GetClassColor(mode.wanted))
    else
        return 'ffffffff'
    end
end

-- Return true if the player is recommended for a specific mode
-- If className is nil, the class is fetched from the unit
-- If mode is nil, use the current mode instead
function SilentRotate:isPlayerWanted(mode, unit, className)
    if className == nil then
        -- The 'select' result must be in parentheses to prevent argument bleeding
        className = (select(2,UnitClass(unit)))
    end

    if mode and mode.wanted then
        if type(mode.wanted) == 'string' then
            -- Single string: check the class matches
            return className == mode.wanted

        elseif type(mode.wanted) == 'table' then
            -- Table: check the class matches with at least one of them
            for _, c in pairs(mode.wanted) do
                if className == c then
                    return true
                end
            end
            return false

        elseif type(mode.wanted) == 'function' then
            -- Function: invoke callback, alongside race info
            local raceName = select(2,UnitRace(unit))
            return mode.wanted(mode, className, raceName)

        end
    end

    return nil
end

-- Return true if the spellId/spellName matches one of the spells of spellWanted
-- spellWanted can be either a spell id, a spell name, a list of ids and names, or a function(spellId, spellName)
function SilentRotate:isSpellInteresting(mode, spellId, spellName)
    local spellWanted = mode.spell

    if not spellWanted then
        return false

    elseif type(spellWanted) == 'number' then -- Single spell ID
        return spellWanted == spellId

    elseif type(spellWanted) == 'string' then -- Single spell name
        return spellWanted == spellName

    elseif type(spellWanted) == 'table' then -- List of spell IDs and/or names
        for _, s in pairs(spellWanted) do
            if type(s) == 'number' and s == spellId
            or type(s) == 'string' and s == spellName then
                return true
            end
        end
        return false

    elseif type(spellWanted) == 'function' then -- Functor
        return spellWanted(mode, spellId, spellName)

    end

    return false
end

-- Get the default duration known for a specific mode
-- If mode is nil, use the current mode instead
function SilentRotate:getModeCooldown(modeName)
    local mode = self:getMode(modeName)

    if mode and mode.cooldown then
        if type(mode.cooldown) == 'number' then
            return mode.cooldown
        elseif type(mode.cooldown) == 'function' then
            return mode.cooldown()
        end
    end

    return nil
end

-- Get the default duration known for an effect (e.g. buff) given by a specific mode
-- If mode is nil, use the current mode instead
-- If the mode provides no effect, the returned duration is zero
function SilentRotate:getModeEffectDuration(modeName)
    local mode = self:getMode(modeName)

    if mode and mode.effectDuration then
        if type(mode.effectDuration) == 'number' then
            return mode.effectDuration
        elseif type(mode.effectDuration) == 'function' then
            return mode.effectDuration()
        end
    end

    return nil
end

-- Each mode has a specific Broadcast text so that it does not conflict with other modes
function SilentRotate:getBroadcastHeaderText()
    local mode = self:getMode()

    if mode and type(mode.modeName) == 'string' then
        return string.format(L['BROADCAST_HEADER_TEXT'], L[mode.modeNameUpper.."_MODE_FULL_NAME"])
    end

    return ''
end


SilentRotate.modes = {}

SilentRotate.modes.tranqShot = {
    oldModeName = 'hunterz',
    default = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC,
    raidOnly = true,
    -- color = nil,
    wanted = 'HUNTER',
    cooldown = 20,
    -- effectDuration = nil,
    canFail = true,
    alertWhenFail = true,
    spell = function(self, spellId, spellName)
        return spellName == GetSpellInfo(19801) -- 'Tranquilizing Shot'
            or spellName == GetSpellInfo(14287) and SilentRotate.testMode -- 'Arcane Shot'
    end,
    -- auraTest = nil,
    customCombatlogFunc = function(self, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, spellId, spellName)
        if event == "SPELL_AURA_APPLIED" and SilentRotate:isBossFrenzy(spellName, sourceGUID) then
            local historyMessage = string.format(SilentRotate:getHistoryPattern("HISTORY_TRANQSHOT_FRENZY"), sourceName, spellName)
            SilentRotate:addHistoryMessage(historyMessage, self)
            if SilentRotate:isPlayerNextTranq() then
                SilentRotate:alertReactNow(self.modeName)
            end
        elseif event == "UNIT_DIED" and SilentRotate:isTranqableBoss(destGUID) then
            SilentRotate:resetRotation()
        end
    end,
    targetGUID = function(self, sourceGUID, destGUID) return destGUID end,
    -- buffName = nil,
    -- buffCanReturn = nil,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    -- assignable = nil,
    -- metadata = nil
}

SilentRotate.modes.loatheb = {
    oldModeName = 'healerz',
    default = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC,
    raidOnly = true,
    color = 'ff3fe7cc', -- Green-ish gooey of Loatheb HS card
    wanted = {'PRIEST', 'PALADIN', 'SHAMAN', 'DRUID'},
    cooldown = 60,
    -- effectDuration = nil,
    -- canFail = nil,
    -- alertWhenFail = nil,
    -- spell = nil,
    auraTest = function(self, spellId, spellName)
        return SilentRotate.testMode and spellId == 11196 -- 11196 is the spell ID of "Recently Bandaged"
            or spellId == 29184 -- priest debuff
            or spellId == 29195 -- druid debuff
            or spellId == 29197 -- paladin debuff
            or spellId == 29199 -- shaman debuff
    end,
    -- customCombatlogFunc = nil,
    -- effectDuration = nil,
    -- targetGUID = nil,
    -- buffName = nil,
    -- buffCanReturn = nil,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'sourceName',
    -- tooltip = nil,
    -- assignable = nil,
    -- metadata = nil
}

SilentRotate.modes.distract = {
    oldModeName = 'roguez',
    default = false,
    raidOnly = false,
    -- color = nil,
    wanted = 'ROGUE',
    cooldown = 30,
    effectDuration = 10,
    canFail = true,
    alertWhenFail = true,
    spell = GetSpellInfo(1725),
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    -- targetGUID = nil,
    -- buffName = nil,
    -- buffCanReturn = nil,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    -- assignable = nil,
    -- metadata = nil
}

SilentRotate.modes.fearWard = {
    oldModeName = 'fearz',
    default = true,
    raidOnly = false,
    color = select(4,GetClassColor('PRIEST')),
    wanted = function(self, className, raceName) return className == 'PRIEST' and (WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC or raceName == 'Dwarf') end,
    cooldown = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) and 30 or 180,
    effectDuration = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) and 600 or 180,
    canFail = false,
    -- alertWhenFail = nil,
    spell = GetSpellInfo(6346),
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    targetGUID = function(self, sourceGUID, destGUID) return destGUID end,
    buffName = function(self, spellId, spellName) return spellName end,
    buffCanReturn = false,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    assignable = 'TANK',
    -- metadata = nil
}

SilentRotate.modes.aoeTaunt = {
    oldModeName = 'tauntz',
    default = false,
    raidOnly = false,
    color = select(4,GetClassColor('WARRIOR')),
    wanted = {'WARRIOR', 'DRUID'},
    cooldown = 600,
    effectDuration = 6,
    canFail = true,
    alertWhenFail = false,
    spell = {
        GetSpellInfo(1161), -- warrior's Challenging Shout
        GetSpellInfo(5209), -- druid's Challenging Roar
    },
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    -- targetGUID = nil,
    -- buffName = nil,
    -- buffCanReturn = nil,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    -- assignable = nil,
    -- metadata = nil
}

SilentRotate.modes.grounding = {
    default = false,
    raidOnly = false,
    -- color = nil,
    wanted = 'SHAMAN',
    cooldown = 15,
    effectDuration = 45,
    canFail = false,
    -- alertWhenFail = nil,
    spell = GetSpellInfo(8177),
    -- auraTest = nil,
    customCombatlogFunc = function(self, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, spellId, spellName)
        if (event == "SPELL_SUMMON") and sourceGUID and sourceName and spellName == self.spell then
            self.metadata.summons[destGUID] = {
                ownerGUID = sourceGUID,
                ownerName = sourceName,
                summoned = true,
                killedAt = nil,
                killedBy = nil,
                killedWith = nil,
            }
            self.metadata.summoners[sourceGUID] = destGUID
            -- Hack for tracking when the totem expires
            -- Because the game client does not always fire the UNIT_DESTROYED event
            -- Wait 2 seconds after the summon to leave some time in case of lag
            C_Timer.After(self.effectDuration+2, function()
                if self.metadata.summoners[sourceGUID] == destGUID and self.metadata.summons[destGUID].summoned then
                    -- Force-fire a false event
                    self:customCombatlogFunc("UNIT_DESTROYED", nil, nil, nil, destGUID, destName)
                end
            end)
        elseif destGUID and self.metadata.summons[destGUID] then
            if (event == "UNIT_DESTROYED") then
                -- The totem was destroyed
                -- This event should always be triggered when the totem dies, in practice it is not always the case
                if self.metadata.summons[destGUID].summoned then
                    self.metadata.summons[destGUID].summoned = false
                    local historyMessage = string.format(SilentRotate:getHistoryPattern("HISTORY_GROUNDING_EXPIRE"), self.metadata.summons[destGUID].ownerName)
                    SilentRotate:addHistoryMessage(historyMessage, self)
                end
            elseif sourceName and spellName then
                -- Check if the caster is attacking to the totem
                -- Because of limitations of the CombatLog, we cannot know for sure if the spell kills the totem
                -- But if we simplify with these conditions it should be okay:
                -- 1. all enemy units are supposed to be "friends" between each other
                -- 2. friendly fire does not happen on the totem
                -- 3. a mind-controlled caster or totem owner will not de-MC during the travel time of a spell
                local ownerName = self.metadata.summons[destGUID].ownerName
                local ownerHostile = not UnitIsPlayer(ownerName) or UnitIsPossessed(ownerName)
                local casterHostile = not UnitIsPlayer(sourceName) or UnitIsPossessed(sourceName)
                local wasSummoned = self.metadata.summons[destGUID].summoned
                if ownerHostile ~= casterHostile then
                    -- In Classic Era, only damage can kill the totem
                    self.metadata.summons[destGUID].summoned = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and event:sub(-7) ~= "_DAMAGE"
                    self.metadata.summons[destGUID].killedAt = GetServerTime()
                    self.metadata.summons[destGUID].killedBy = sourceName
                    if event:sub(0,5) == "SPELL" then
                        self.metadata.summons[destGUID].killedWith = spellName
                    end
                end

                local totem = self.metadata.summons[destGUID]
                local isNowSummoned = totem.summoned
                if wasSummoned ~= isNowSummoned then
                    local ownerGUID = totem.ownerGUID
                    local hunter = SilentRotate:getHunter(ownerGUID)
                    if hunter then
                        local historyMessage
                        if totem.killedWith then
                            historyMessage = string.format(SilentRotate:getHistoryPattern("HISTORY_GROUNDING_ABSORB"), totem.ownerName, totem.killedWith, totem.killedBy)
                        else
                            historyMessage = string.format(SilentRotate:getHistoryPattern("HISTORY_GROUNDING_ABSORB_NOSPELL"), totem.ownerName, totem.killedBy)
                        end
                        SilentRotate:addHistoryMessage(historyMessage, self)
                    end
                end
            end
        elseif (event == "SPELL_CAST_SUCCESS") then
            -- cancellersQuickSearch is built lazy
            local cancellersQuickSearch = self.metadata.cancellersQuickSearch
            if not cancellersQuickSearch then
                cancellersQuickSearch = {}
                for _, cancellerSpellName in pairs(self.metadata.cancellers) do
                    if cancellerSpellName then -- Mus check existence because not all spells exist in all 'projects'
                        cancellersQuickSearch[cancellerSpellName] = true
                    end
                end
                self.metadata.cancellersQuickSearch = cancellersQuickSearch
            end

            if self.metadata.cancellersQuickSearch[spellName] then
                local totemGUID = self.metadata.summoners[sourceGUID]
                local totem = self.metadata.summons[totemGUID]
                if totem and totem.summoned then
                    totem.summoned = false
                    local historyMessage = string.format(SilentRotate:getHistoryPattern("HISTORY_GROUNDING_CANCEL"), totem.ownerName, spellName)
                    SilentRotate:addHistoryMessage(historyMessage, self)
                end
            end
        elseif (event == "UNIT_DIED") and destGUID and self.metadata.summoners[destGUID] then
            -- The author of a totem has died
            local totemGUID = self.metadata.summoners[destGUID]
            local totem = self.metadata.summons[totemGUID]
            if totem and totem.summoned then
                totem.summoned = false
                local historyMessage = string.format(SilentRotate:getHistoryPattern("HISTORY_GROUNDING_ORPHAN"), totem.ownerName)
                SilentRotate:addHistoryMessage(historyMessage, self)
            end
        end
    end,
    targetGUID = function(self, sourceGUID, destGUID) return sourceGUID end, -- Target is the caster itself
    buffName = function(self, spellId, spellName) return self.metadata.groundingTotemEffectName end, -- Buff is the totem effect
    buffCanReturn = true,
    customTargetName = function(self, hunter, targetName)
        local totemGUID = self.metadata.summoners[hunter.GUID]
        local totem = self.metadata.summons[totemGUID]
        if not totemGUID or totem.summoned then
            -- Totem still active: display the group where it belongs
            return hunter.subgroup and string.format(SilentRotate.db.profile.groupSuffix, hunter.subgroup)
        elseif totem.killedWith then
            -- Totem destroyed by spell: display the spell name only
            return totem.killedWith
        elseif totem.killedBy then
            -- Totem destroyed not by a spell: display the culprit only
            return totem.killedBy
        else
            -- Expired, display nothing
            return nil
        end
    end,
    customHistoryFunc = function(self, hunter, sourceName, destName, spellName, failed)
        return string.format(SilentRotate:getHistoryPattern("HISTORY_GROUNDING_SUMMON"), sourceName, hunter.subgroup or 0)
    end,
    groupChangeFunc = function(self, hunter, oldgroup, newgroup)
        local totemGUID = self.metadata.summoners[hunter.GUID]
        local totem = self.metadata.summons[totemGUID]
        if totemGUID and totem.summoned then
            local historyMessage = string.format(SilentRotate:getHistoryPattern("HISTORY_GROUNDING_CHANGE"), totem.ownerName, newgroup)
            SilentRotate:addHistoryMessage(historyMessage, self)
        end
    end,
    announceArg = 'sourceGroup',
    tooltip = function(self, hunter)
        local totemGUID = self.metadata.summoners[hunter.GUID]
        local totem = self.metadata.summons[totemGUID]
        if totem and not totem.summoned and totem.killedAt and totem.killedBy then
            if totem.killedWith then
                return string.format("[%s] %s (%s)", date("%H:%M:%S", totem.killedAt), totem.killedWith, totem.killedBy)
            else
                return string.format("[%s] %s", date("%H:%M:%S", totem.killedAt), totem.killedBy)
            end
        end
        return nil
    end,
    -- assignable = nil,
    metadata = {
        groundingTotemEffectName = GetSpellInfo(8178), -- The buff is the name from spellId+1, not from spellId
        cancellers = {
            (GetSpellInfo(8835)), -- Grace of Air Totem rank 1
            (GetSpellInfo(10595)), -- Nature Resistance Totem rank 1
            (GetSpellInfo(6495)), -- Sentry Totem
            (GetSpellInfo(25908)), -- Tranquil Air Totem
            (GetSpellInfo(8512)), -- Windfury Totem rank 1
            (GetSpellInfo(15107)), -- Wind Wall Totem rank 1
            (GetSpellInfo(3738)), -- Wrath of Air Totem rank 1, introduced in Burning Crusade
            (GetSpellInfo(36936)), -- Totemic Call, introduced in Burning Crusade
        },
        summons = {},
        summoners = {}
    },
}

SilentRotate.modes.brez = {
    default = false,
    raidOnly = false,
    -- color = nil,
    wanted = 'DRUID',
    cooldown = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) and 1800 or 1200,
    -- effectDuration = nil,
    canFail = false,
    -- alertWhenFail = nil,
    spell = GetSpellInfo(20484), -- Rebirth Rank 1
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    targetGUID = function(self, sourceGUID, destGUID) return destGUID end,
    -- buffName = nil,
    -- buffCanReturn = nil,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    -- assignable = nil,
    -- metadata = nil
}

SilentRotate.modes.innerv = {
    default = false,
    raidOnly = false,
    -- color = nil,
    wanted = 'DRUID',
    cooldown = 360,
    effectDuration = 20,
    canFail = false,
    -- alertWhenFail = nil,
    spell = GetSpellInfo(29166),
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    targetGUID = function(self, sourceGUID, destGUID) return destGUID end,
    buffName = function(self, spellId, spellName) return spellName end,
    buffCanReturn = false,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    assignable = 'MANA',
    -- metadata = nil
}

SilentRotate.modes.bop = {
    default = false,
    raidOnly = false,
    -- color = nil,
    wanted = 'PALADIN',
    cooldown = 300,
    effectDuration = 10,
    canFail = false,
    -- alertWhenFail = nil,
    spell = GetSpellInfo(1022), -- Blessing of Protection rank 1
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    targetGUID = function(self, sourceGUID, destGUID) return destGUID end,
    buffName = function(self, spellId, spellName) return spellName end,
    buffCanReturn = false,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    -- assignable = nil,
    -- metadata = nil
}

SilentRotate.modes.bof = {
    default = false,
    raidOnly = false,
    -- color = nil,
    wanted = 'PALADIN',
    cooldown = 25,
    effectDuration = 10,
    canFail = false,
    -- alertWhenFail = nil,
    spell = GetSpellInfo(1044), -- Blessing of Freedom
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    targetGUID = function(self, sourceGUID, destGUID) return destGUID end,
    buffName = function(self, spellId, spellName) return spellName end,
    buffCanReturn = false,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    -- assignable = nil,
    -- metadata = nil
}

SilentRotate.modes.soulstone = {
    default = false,
    raidOnly = false,
    -- color = nil,
    wanted = 'WARLOCK',
    cooldown = 1800,
    effectDuration = 1800,
    canFail = false,
    -- alertWhenFail = nil,
    spell = GetSpellInfo(20707), -- Soulstone Resurrection rank 1
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    targetGUID = function(self, sourceGUID, destGUID) return destGUID end,
    buffName = function(self, spellId, spellName) return spellName end,
    buffCanReturn = false,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    assignable = { 'TANK', 'REZ' },
    -- metadata = nil
}

-- Modes available for The Burning Crusade Classic
if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then

SilentRotate.modes.misdi = {
    oldModeName = 'misdiz',
    default = WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC,
    raidOnly = false,
    -- color = nil,
    wanted = 'HUNTER',
    cooldown = 120,
    effectDuration = 30,
    canFail = false,
    -- alertWhenFail = nil,
    spell = GetSpellInfo(34477),
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    targetGUID = function(self, sourceGUID, destGUID) return destGUID end,
    buffName = function(self, spellId, spellName) return spellName end,
    buffCanReturn = false,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    assignable = 'TANK',
    -- metadata = nil
}

SilentRotate.modes.bloodlust = {
    oldModeName = 'shamanz',
    default = WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC,
    raidOnly = false,
    -- color = nil,
    wanted = 'SHAMAN',
    cooldown = 600,
    effectDuration = 40,
    canFail = false,
    -- alertWhenFail = nil,
    spell = {
        GetSpellInfo(2825), -- Bloodlust
        GetSpellInfo(32182), -- Heroism
    },
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    targetGUID = function(self, sourceGUID, destGUID) return sourceGUID end, -- Target is the caster itself
    buffName = function(self, spellId, spellName) return spellName end,
    buffCanReturn = false,
    customTargetName = function(self, hunter, targetName) return hunter.subgroup and string.format(SilentRotate.db.profile.groupSuffix, hunter.subgroup) end,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'sourceGroup',
    -- tooltip = nil,
    -- assignable = nil,
    -- metadata = nil
}

SilentRotate.modes.soulwell = {
    default = false,
    raidOnly = false,
    -- color = nil,
    wanted = 'WARLOCK',
    cooldown = 300,
    effectDuration = 180,
    canFail = false,
    -- alertWhenFail = nil,
    spell = GetSpellInfo(29893), -- Ritual of Souls rank 1
    -- auraTest = nil,
    -- customCombatlogFunc = nil,
    -- targetGUID = nil,
    -- buffName = nil,
    -- buffCanReturn = nil,
    -- customTargetName = nil,
    -- customHistoryFunc = nil,
    -- groupChangeFunc = nil,
    announceArg = 'destName',
    -- tooltip = nil,
    -- assignable = nil,
    -- metadata = nil
}

end

-- Create a backward compatibility map between old mode names and new ones
-- And fill some attributes automatically
SilentRotate.backwardCompatibilityModeMap = {}
for modeName, mode in pairs(SilentRotate.modes) do
    mode.modeName = modeName
    mode.modeNameUpper = modeName:upper()
    mode.modeNameFirstUpper = modeName:gsub("^%l", string.upper)
    if type(mode.oldModeName) == 'string' then
        SilentRotate.backwardCompatibilityModeMap[mode.oldModeName] = modeName
    end
end
