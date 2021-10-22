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

    ['tranqableBosses'] = {
        [11982] = 19451, -- Magmadar (MC)
        [11981] = 23342, -- Flamegor (BWL)
        [14020] = 23342, -- Chromaggus (BWL)
        [15509] = 19451, -- Huhuran (AQ40)
        [15932] = 19451, -- Gluth (Naxx)
    },
}
