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
        modeName = 'tranqShot',
        oldModeName = 'hunterz',
        project = nil,
        wanted = 'HUNTER',
        cooldown = 20,
        effectDuration = nil,
        targetName = nil,
        spellTest = function(spellName) return spellName == SilentRotate.constants.tranqShot or (SilentRotate.testMode and spellName == SilentRotate.constants.arcaneShot) end,
        spellCanFail = true,
        auraTest = nil,
    },

    loatheb = {
        modeName = 'loatheb',
        oldModeName = 'healerz',
        project = nil, -- function() return WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC end
        wanted = function(unit, className) return className == 'PRIEST' or className == 'PALADIN' or className == 'SHAMAN' or className == 'DRUID' end,
        cooldown = 60,
        effectDuration = nil,
        targetName = nil,
        spellTest = nil,
        spellCanFail = nil,
        auraTest = function(spellId) return SilentRotate:isLoathebDebuff(spellId) or (SilentRotate.testMode and spellId == 11196) end,
    },

	        -- announceDistractSuccessMessage 	= L["DEFAULT_DISTRACT_SUCCESS_ANNOUNCE_MESSAGE"],
	        -- announceDistractFailMessage 	= L["DEFAULT_DISTRACT_FAIL_ANNOUNCE_MESSAGE"],
	        -- announceFearWardMessage 		= L["DEFAULT_FEARWARD_ANNOUNCE_MESSAGE"],
	        -- announceAoeTauntSuccessMessage 	= L["DEFAULT_AOETAUNT_SUCCESS_ANNOUNCE_MESSAGE"],
	        -- announceAoeTauntFailMessage 	= L["DEFAULT_AOETAUNT_FAIL_ANNOUNCE_MESSAGE"],
			-- announceMisdiMessage 			= L["DEFAULT_MISDI_ANNOUNCE_MESSAGE"],
			-- announceBloodlustMessage 		= L["DEFAULT_BLOODLUST_ANNOUNCE_MESSAGE"],
}

-- Create a backward compatibility map between old mode names and new ones
-- And fill some attributes automatically
SilentRotate.backwardCompatibilityModeMap = {}
for modeName, mode in pairs(SilentRotate.modes) do
    assert(modeName == mode.modeName)
    mode.modeNameUpper = modeName:upper()
    mode.modeNameFirstUpper = modeName:gsub("^%l", string.upper)
    SilentRotate.backwardCompatibilityModeMap[mode.oldModeName] = modeName
end
