local SilentRotate = select(2, ...)

SilentRotate.colors = {
    ['green'] = CreateColor(0.67, 0.83, 0.45),
    ['darkGreen'] = CreateColor(0.1, 0.4, 0.1),
    ['darkBlue'] = CreateColor(0.1, 0.1, 0.4),
    ['blue'] = CreateColor(0.3, 0.3, 0.7),
    ['red'] = CreateColor(0.7, 0.3, 0.3),
    ['darkGray'] = CreateColor(0.3, 0.3, 0.3),
    ['lightGray'] = CreateColor(0.8, 0.8, 0.8),
    ['purple'] = CreateColor(0.71,0.45,0.75),
    ['white'] = CreateColor(1,1,1),
}

SilentRotate.constants = {
    ['hunterFrameHeight'] = 22,
    ['hunterFrameSpacing'] = 4,
    ['titleBarHeight'] = 18,
    ['modeBarHeight'] = 18,
    ['mainFrameWidth'] = 130,
    ['rotationFramesBaseHeight'] = 20,

    ['commsPrefix'] = {
        ['hunterz'] = 'srhunterz',
        ['priestz'] = 'srpriestz',
--        ['healerz'] = 'srhealerz',
        ['healerz'] = 'silentrotate', -- for compatibility purposes
        ['roguez' ] = 'srroguez'
    },

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

    ['distract'] = GetSpellInfo(1725)
}
