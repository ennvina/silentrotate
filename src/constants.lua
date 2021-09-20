local SilentRotate = select(2, ...)

SilentRotate.colors = {
    ['white']       = CreateColor(1,1,1),

    ['lightRed']    = CreateColor(1.0, 0.4, 0.4),
    ['red']         = CreateColor(0.7, 0.3, 0.3),

    ['green']       = CreateColor(0.67, 0.83, 0.45),
    ['darkGreen']   = CreateColor(0.1, 0.4, 0.1),

    ['blue']        = CreateColor(0.3, 0.3, 0.7),
    ['darkBlue']    = CreateColor(0.1, 0.1, 0.4),

    ['lightGray']   = CreateColor(0.8, 0.8, 0.8),
    ['darkGray']    = CreateColor(0.3, 0.3, 0.3),

    ['lightCyan']   = CreateColor(0.5, 0.8, 1),

    ['purple']      = CreateColor(0.71, 0.45, 0.75),

    -- Below are user-defined colors
    ['groupSuffix'] = nil,
    ['indexPrefix'] = nil,
    ['neutral'] = nil,
    ['active'] = nil,
    ['dead'] = nil,
    ['offline'] = nil,
}

SilentRotate.constants = {
    ['hunterFrameHeight'] = 22,
    ['hunterFrameSpacing'] = 4,
    ['titleBarHeight'] = 18,
    ['modeBarHeight'] = 18,
    ['modeFrameFontSize'] = 12,
    ['modeFrameMargin'] = 2,
    ['mainFrameWidth'] = 130,
    ['rotationFramesBaseHeight'] = 20,

    ['commsPrefix'] = 'silentrotate',

    ['commsChannel'] = 'RAID',

    ['commsTypes'] = {
        ['tranqshotDone'] = 'tranqshot-done',
        ['syncOrder'] = 'sync-order',
        ['syncRequest'] = 'sync-request',
    },

    ['printPrefix'] = 'SilentRotate - ',
    ['duplicateTranqshotDelayThreshold'] = 10,

    ['minimumCooldownElapsedForEligibility'] = 10,

    ['sounds'] = {
        ['nextToTranq'] = 'Interface\\AddOns\\SilentRotate\\sounds\\ding.ogg',
        ['alarms'] = {
            ['alarm1'] = 'Interface\\AddOns\\SilentRotate\\sounds\\alarm.ogg',
            ['alarm2'] = 'Interface\\AddOns\\SilentRotate\\sounds\\alarm2.ogg',
            ['alarm3'] = 'Interface\\AddOns\\SilentRotate\\sounds\\alarm3.ogg',
            ['alarm4'] = 'Interface\\AddOns\\SilentRotate\\sounds\\alarm4.ogg',
            ['flagtaken'] = 'Sound\\Spells\\PVPFlagTaken.ogg',
        }
    },

    ['tranqNowSounds'] = {
        ['alarm1'] = 'Loud BUZZ',
        ['alarm2'] = 'Gentle beeplip',
        ['alarm3'] = 'Gentle dong',
        ['alarm4'] = 'Light bipbip',
        ['flagtaken'] = 'Flag Taken (DBM)',
    },

    ['tranqShot'] = GetSpellInfo(19801),
    ['arcaneShot'] = GetSpellInfo(14287),
    ['bosses'] = {
        [11982] = 19451, -- magmadar
        [11981] = 23342, -- flamegor
        [14020] = 23342, -- chromaggus
        [15509] = 19451, -- huhuran
        [15932] = 19451, -- gluth
    },

    ['loatheb'] = {
        29184, -- priest debuff
        29195, -- druid debuff
        29197, -- paladin debuff
        29199, -- shaman debuff
    },

    ['distract'] = GetSpellInfo(1725),

    ['fearWard'] = GetSpellInfo(6346),

    ['aoeTaunt'] = {
        GetSpellInfo(1161), -- warrior's challenging shout
        GetSpellInfo(5209), -- druid's challenging roar
    },

    ['misdi'] = GetSpellInfo(34477),

    ['bloodlust'] = {
        GetSpellInfo(2825), -- Bloodlust
        GetSpellInfo(32182), -- Heroism
    },

}

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
