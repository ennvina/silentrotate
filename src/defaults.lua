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
			currentMode = nil, -- Will be set based on *modeButton flags at the end of this file
			tranqModeButton    = SilentRotate:isClassWanted(select(2,UnitClass("player")), 'hunterz'),
			loathebModeButton  = SilentRotate:isClassWanted(select(2,UnitClass("player")), 'healerz'),
			distractModeButton = SilentRotate:isClassWanted(select(2,UnitClass("player")), 'roguez'),
			razModeButton = false, -- SilentRotate:isClassWanted(select(2,UnitClass("player")), 'priestz'), -- Do not allow Razuvious mode for now
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
	-- Find the default mode based on class compatibility
	if (self.defaults.profile.tranqModeButton) then
		self.defaults.profile.currentMode = 'hunterz'
	elseif (self.defaults.profile.loathebModeButton) then
		self.defaults.profile.currentMode = 'healerz'
	elseif (self.defaults.profile.distractModeButton) then
		self.defaults.profile.currentMode = 'roguez'
	else
		-- Use Loatheb mode by default for classes who cannot fit other roles
		-- Also enable this option by default
		self.defaults.profile.tranqModeButton = true
		self.defaults.profile.currentMode = 'hunterz'
	end
end
