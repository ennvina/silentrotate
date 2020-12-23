local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

function SilentRotate:LoadDefaults()
	self.defaults = {
	    profile = {
			-- Messaging
	        enableAnnounces = true,
	        channelType = "YELL",
	        rotationReportChannelType = "RAID",
	        useMultilineRotationReport = false,
	        announceSuccessMessage = L["DEFAULT_SUCCESS_ANNOUNCE_MESSAGE"],
	        announceFailMessage = L["DEFAULT_FAIL_ANNOUNCE_MESSAGE"],
			whisperFailMessage = L["DEFAULT_FAIL_WHISPER_MESSAGE"],
	        announceLoathebMessage = L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"],

			-- Modes
			tranqModeButton    = SilentRotate:IsClassWanted(select(2,UnitClass("player")), 'hunterz'),
			loathebModeButton  = SilentRotate:IsClassWanted(select(2,UnitClass("player")), 'healerz'),
			distractModeButton = SilentRotate:IsClassWanted(select(2,UnitClass("player")), 'roguez'),
			razModeButton = false, -- SilentRotate:IsClassWanted(select(2,UnitClass("player")), 'priestz'), -- Do not allow Razuvious mode for now
			tranqModeText    = L["FILTER_SHOW_HUNTERS"],
			loathebModeText  = L["FILTER_SHOW_HEALERS"],
			distractModeText = L["FILTER_SHOW_ROGUES"],
			razModeText      = L["FILTER_SHOW_PRIESTS"],

			-- Names
			useClassColor = true,
			useNameOutline = false,
			appendGroup = false,
			groupSuffix = L["DEFAULT_GROUP_SUFFIX_MESSAGE"],
			groupSuffixColor = {SilentRotate.colors.lightGray:GetRGB()},

			-- Background
			neutralBackgroundColor = {SilentRotate.colors.lightGray:GetRGB()},
			activeBackgroundColor  = {SilentRotate.colors.purple:GetRGB()},
			deadBackgroundColor    = {SilentRotate.colors.red:GetRGB()},
			offlineBackgroundColor = {SilentRotate.colors.darkGray:GetRGB()},

			-- Sounds
			enableNextToTranqSound = true,
			enableTranqNowSound = true,
			tranqNowSound = 'alarm1',

			-- Miscellaneous
			lock = false,
			hideNotInRaid = false,
			doNotShowWindowOnRaidJoin = false,
			showWindowWhenTargetingBoss = false,
	    },
	}
end
