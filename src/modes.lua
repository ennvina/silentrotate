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
        modeName = SilentRotate.backwardCompatibilityModeMap[modeName]
    end

    -- return the mode object, or TranqShot as the default mode if no mode is set
    return SilentRotate.modes[modeName or SilentRotate.modes.tranqShot.modeName]
end

function SilentRotate:isTranqShotMode(modeName)
    local mode = self:getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.tranqShot.modeName
end

function SilentRotate:isLoathebMode(modeName)
    local mode = self:getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.loatheb.modeName
end

function SilentRotate:isDistractMode(modeName)
    local mode = self:getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.distract.modeName
end

function SilentRotate:isFearWardMode(modeName)
    local mode = self:getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.fearWard.modeName
end

function SilentRotate:isAoeTauntMode(modeName)
    local mode = self:getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.aoeTaunt.modeName
end

function SilentRotate:isMisdiMode(modeName)
    local mode = self:getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.misdi.modeName
end

function SilentRotate:isBloodlustMode(modeName)
    local mode = self:getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.bloodlust.modeName
end

-- Activate the specific mode
function SilentRotate:activateMode(modeName)
    local currentMode = self:getMode()
    local paramMode = self:getMode(modeName)
    if currentMode.modeName == paramMode.modeName then return end

    oldFrame = SilentRotate.mainFrame.modeFrames[currentMode.modeName]
    if oldFrame then
        oldFrame.texture:SetColorTexture(SilentRotate.colors.darkBlue:GetRGB())
    end

    newFrame = SilentRotate.mainFrame.modeFrames[modeName]
    if newFrame then
        SilentRotate.db.profile.currentMode = modeName
        newFrame.texture:SetColorTexture(SilentRotate.colors.blue:GetRGB())
        SilentRotate:updateRaidStatus()
        local AceConfigDialog = LibStub("AceConfigDialog-3.0")
        AceConfigDialog:ConfigTableChanged("", Addon)
    end
end

-- Return true if the player is recommended for a specific mode
-- If className is nil, the class is fetched from the unit
-- If mode is nil, use the current mode instead
function SilentRotate:isPlayerWanted(unit, className, modeName)
    if className == nil then
        className = (select(2,UnitClass(unit)))
    end

    local mode = self:getMode(modeName)
    if mode and mode.wanted then
        if type(mode.wanted) == 'string' then
            return className == mode.wanted
        elseif type(mode.wanted == 'function') then
            return mode.wanted(unit, className)
        end
    end

    return nil
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
        return L['BROADCAST_HEADER_TEXT_'..mode.modeNameUpper]
    end

    return ''
end


SilentRotate.modes = {
    tranqShot = {
        oldModeName = 'hunterz',
        project = true,
        default = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC,
        wanted = 'HUNTER',
        cooldown = 20,
        -- effectDuration = nil,
        canFail = true,
        spellTest = function(spellName) return spellName == SilentRotate.constants.tranqShot or (SilentRotate.testMode and spellName == SilentRotate.constants.arcaneShot) end,
        -- auraTest = nil,
        customCombatlogFunc = function(event, sourceGUID, sourceName, sourceFlags, destGUID, destName, spellId, spellName)
            if event == "SPELL_AURA_APPLIED" and SilentRotate:isBossFrenzy(spellName, sourceGUID) and SilentRotate:isPlayerNextTranq() then
                SilentRotate:throwTranqAlert()
            elseif event == "UNIT_DIED" and SilentRotate:isTranqableBoss(destGUID) then
                SilentRotate:resetRotation()
            end
        end,
        targetGUID = function(sourceGUID, destGUID) return SilentRotate:getPlayerGuid(destGUID) end,
        -- targetSpell = nil,
        -- customTargetName = nil,
        announceArg = function(hunter, destName) return destName end,
    },

    loatheb = {
        oldModeName = 'healerz',
        project = true,
        default = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC,
        wanted = function(unit, className) return className == 'PRIEST' or className == 'PALADIN' or className == 'SHAMAN' or className == 'DRUID' end,
        cooldown = 60,
        -- canFail = nil,
        -- spellTest = nil,
        auraTest = function(spellId) return SilentRotate:isLoathebDebuff(spellId) or (SilentRotate.testMode and spellId == 11196) end, -- 11196 is the spell ID of "Recently Bandaged"
        -- customCombatlogFunc = nil,
        -- effectDuration = nil,
        -- targetGUID = nil,
        -- targetSpell = nil,
        -- customTargetName = nil,
        announceArg = function(hunter, destName) return destName end,
    },

--    distract = {},

    -- elseif SilentRotate:isFearWardMode() then
    --     if (event == "SPELL_CAST_SUCCESS" and ) then
    --         local hunter = SilentRotate:getHunter(sourceGUID)
    --         SilentRotate:sendSyncTranq(hunter, false, timestamp)
    --         SilentRotate:rotate(hunter, false, nil, nil, nil, SilentRotate:getPlayerGuid(destGUID), spellName)
    --         if (sourceGUID == UnitGUID("player")) then
    --             SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceFearWardMessage, destName)
    --         end
    --     end

    fearWard = {
        oldModeName = 'priestz',
        project = true,
        default = true,
        wanted = function(unit, className) return className == 'PRIEST' and (WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC or select(2,UnitRace(unit)) == 'Dwarf') end,
        cooldown = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) and 30 or 180,
        effectDuration = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) and 600 or 180,
        canFail = false,
        spellTest = function(spellName) return SilentRotate:isFearWardSpell(spellName) end,
        -- auraTest = nil,
        -- customCombatlogFunc = nil,
        targetGUID = function(sourceGUID, destGUID) return SilentRotate:getPlayerGuid(destGUID) end,
        targetSpell = function(spellId, spellName) return spellName end,
        -- customTargetName = nil,
        announceArg = function(hunter, destName) return destName end,
    },

--    aoeTaunt = {},

--    misdi = {},

    -- if SilentRotate:isBloodlustMode() then
    --     if (event == "SPELL_CAST_SUCCESS" and ) then
    --         local hunter = SilentRotate:getHunter(sourceGUID)
    --         SilentRotate:sendSyncTranq(hunter, false, timestamp)
    --         SilentRotate:rotate(hunter, false, nil, nil, nil, SilentRotate:getPlayerGuid(sourceGUID), spellName) -- Target is the caster itself
    --         if (sourceGUID == UnitGUID("player")) then
    --             SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceBloodlustMessage, hunter.subgroup or 0)
    --         end
    --     end

    bloodlust = {
        oldModeName = 'shamanz',
        project = WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC,
        default = WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC,
        wanted = 'SHAMAN',
        cooldown = 600,
        effectDuration = 40,
        canFail = false,
        spellTest = function(spellName) return SilentRotate:isBloodlustSpell(spellName) end,
        -- auraTest = nil,
        -- customCombatlogFunc = nil,
        targetGUID = function(sourceGUID, destGUID) return SilentRotate:getPlayerGuid(sourceGUID) end, -- Target is the caster itself
        targetSpell = function(spellId, spellName) return spellName end,
        customTargetName = function(hunter, targetName) return string.format(SilentRotate.db.profile.groupSuffix, hunter.subgroup or 0) end,
        announceArg = function(hunter, destName) return hunter.subgroup or 0 end,
    },

	        -- announceDistractSuccessMessage 	= L["DEFAULT_DISTRACT_SUCCESS_ANNOUNCE_MESSAGE"],
	        -- announceDistractFailMessage 	= L["DEFAULT_DISTRACT_FAIL_ANNOUNCE_MESSAGE"],
	        -- announceFearWardMessage 		= L["DEFAULT_FEARWARD_ANNOUNCE_MESSAGE"],
	        -- announceAoeTauntSuccessMessage 	= L["DEFAULT_AOETAUNT_SUCCESS_ANNOUNCE_MESSAGE"],
	        -- announceAoeTauntFailMessage 	= L["DEFAULT_AOETAUNT_FAIL_ANNOUNCE_MESSAGE"],
			-- announceMisdiMessage 			= L["DEFAULT_MISDI_ANNOUNCE_MESSAGE"],
			-- announceBloodlustMessage 		= L["DEFAULT_BLOODLUST_ANNOUNCE_MESSAGE"],

    -- elseif SilentRotate:isDistractMode(mode) then
    --     return className == 'ROGUE'
    -- elseif SilentRotate:isAoeTauntMode(mode) then
    --     return className == 'WARRIOR' or className == 'DRUID'
    -- elseif SilentRotate:isMisdiMode(mode) then
    --     return className == 'HUNTER'
    -- else
    --     return className == 'HUNTER' -- hunter is the default mode

    -- if SilentRotate:isTranqShotMode() then
    --     duration = 20 -- Cooldown of Hunter's Tranquilizing Shot
    -- elseif SilentRotate:isLoathebMode() then
    --     duration = 60 -- Corrupted Mind debuff that prevents healing spells
    -- elseif SilentRotate:isDistractMode() then
    --     duration = 30 -- Cooldown of Rogue's Distract
    -- elseif SilentRotate:isAoeTauntMode() then
    --     duration = 600 -- Cooldown of Warrior's Challenging Shout and Druid's Challenging Roar
    -- elseif SilentRotate:isMisdiMode() then
    --     duration = 120 -- Cooldown of Hunter's Misdirection
    -- else
    --     duration = 0 -- Duration should have no meaning for other modes
    -- end

    -- if SilentRotate:isDistractMode() then
    --     duration = 10
    -- elseif SilentRotate:isAoeTauntMode() then
    --     duration = 6
    -- elseif SilentRotate:isMisdiMode() then
    --     duration = 30
    -- else
    --     duration = 0 -- Other modes provide no specific buff/debuff
    -- end

    -- if SilentRotate:isTranqShotMode() then
    --     if (spellName == SilentRotate.constants.tranqShot or (SilentRotate.testMode and spellName == SilentRotate.constants.arcaneShot)) then
    --         local hunter = SilentRotate:getHunter(sourceGUID)
    --         if (event == "SPELL_CAST_SUCCESS") then
    --             SilentRotate:sendSyncTranq(hunter, false, timestamp)
    --             SilentRotate:rotate(hunter, false, nil, nil, nil, SilentRotate:getPlayerGuid(destGUID))
    --             if (sourceGUID == UnitGUID("player")) then
    --                 SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceTranqshotSuccessMessage, destName)
    --             end
    --         elseif (event == "SPELL_MISSED") then
    --             SilentRotate:sendSyncTranq(hunter, true, timestamp)
    --             SilentRotate:rotate(hunter, true, nil, nil, nil, SilentRotate:getPlayerGuid(destGUID))
    --             if (sourceGUID == UnitGUID("player")) then
    --                 SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceTranqshotFailMessage, destName)
    --             end
    --         end
    --     elseif (event == "SPELL_AURA_APPLIED" and SilentRotate:isBossFrenzy(spellName, sourceGUID) and SilentRotate:isPlayerNextTranq()) then
    --         SilentRotate:throwTranqAlert()
    --     elseif event == "UNIT_DIED" and SilentRotate:isTranqableBoss(destGUID) then
    --         SilentRotate:resetRotation()
    --     end
    -- elseif SilentRotate:isDistractMode() then
    --     if SilentRotate:isDistractSpell(spellName) then
    --         local hunter = SilentRotate:getHunter(sourceGUID)
    --         if (event == "SPELL_CAST_SUCCESS") then
    --             SilentRotate:sendSyncTranq(hunter, false, timestamp)
    --             SilentRotate:rotate(hunter, false, nil, nil, nil, SilentRotate.testMode and SilentRotate:getPlayerGuid(destGUID) or nil)
    --             if (sourceGUID == UnitGUID("player")) then
    --                 SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceDistractSuccessMessage)
    --             end
    --         elseif (event == "SPELL_MISSED") then
    --             SilentRotate:sendSyncTranq(hunter, true, timestamp)
    --             SilentRotate:rotate(hunter, true, nil, nil, nil, SilentRotate.testMode and SilentRotate:getPlayerGuid(destGUID) or nil)
    --             if (sourceGUID == UnitGUID("player")) then
    --                 SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceDistractFailMessage)
    --             end
    --         end
    --     end
    -- elseif SilentRotate:isAoeTauntMode() then
    --     if SilentRotate:isAoeTauntSpell(spellName) then
    --         local hunter = SilentRotate:getHunter(sourceGUID)
    --         if (event == "SPELL_CAST_SUCCESS") then
    --             SilentRotate:sendSyncTranq(hunter, false, timestamp)
    --             SilentRotate:rotate(hunter, false, nil, nil, nil, SilentRotate.testMode and SilentRotate:getPlayerGuid(destGUID) or nil, SilentRotate.testMode and spellName or nil)
    --             if (sourceGUID == UnitGUID("player")) then
    --                 SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceAoeTauntSuccessMessage)
    --             end
    --         elseif (event == "SPELL_MISSED") then
    --             SilentRotate:sendSyncTranq(hunter, true, timestamp)
    --             SilentRotate:rotate(hunter, true, nil, nil, nil, SilentRotate.testMode and SilentRotate:getPlayerGuid(destGUID) or nil, SilentRotate.testMode and spellName or nil)
    --             if (sourceGUID == UnitGUID("player")) then
    --                 SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceAoeTauntFailMessage)
    --             end
    --         end
    --     end
    -- elseif SilentRotate:isMisdiMode() then
    --     if (event == "SPELL_CAST_SUCCESS" and SilentRotate:isMisdiSpell(spellName)) then
    --         local hunter = SilentRotate:getHunter(sourceGUID)
    --         SilentRotate:sendSyncTranq(hunter, false, timestamp)
    --         SilentRotate:rotate(hunter, false, nil, nil, nil, SilentRotate:getPlayerGuid(destGUID), spellName)
    --         if (sourceGUID == UnitGUID("player")) then
    --             SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceMisdiMessage, destName)
    --         end
    --     end
    -- end
}

-- Create a backward compatibility map between old mode names and new ones
-- And fill some attributes automatically
SilentRotate.backwardCompatibilityModeMap = {}
for modeName, mode in pairs(SilentRotate.modes) do
    mode.modeName = modeName
    mode.modeNameUpper = modeName:upper()
    mode.modeNameFirstUpper = modeName:gsub("^%l", string.upper)
    SilentRotate.backwardCompatibilityModeMap[mode.oldModeName] = modeName
end
