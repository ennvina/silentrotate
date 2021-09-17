local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

function SilentRotate:LoadDefaults()
	self.defaults = {
	    profile = {
			-- Messaging
	        enableAnnounces = true,
	        channelType = "YELL",
	        rotationReportChannelType = "RAID",
	        useMultilineRotationReport = false,
	        announceTranqshotSuccessMessage = L["DEFAULT_TRANQSHOT_SUCCESS_ANNOUNCE_MESSAGE"],
	        announceTranqshotFailMessage = L["DEFAULT_TRANQSHOT_FAIL_ANNOUNCE_MESSAGE"],
			whisperFailMessage = L["DEFAULT_TRANQSHOT_FAIL_WHISPER_MESSAGE"], -- not used anymore, kept for compatibility
	        announceLoathebMessage = L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"],
	        announceDistractSuccessMessage = L["DEFAULT_DISTRACT_SUCCESS_ANNOUNCE_MESSAGE"],
	        announceDistractFailMessage = L["DEFAULT_DISTRACT_FAIL_ANNOUNCE_MESSAGE"],
	        announceFearWardMessage = L["DEFAULT_FEARWARD_ANNOUNCE_MESSAGE"],
	        announceAoeTauntSuccessMessage = L["DEFAULT_AOETAUNT_SUCCESS_ANNOUNCE_MESSAGE"],
	        announceAoeTauntFailMessage = L["DEFAULT_AOETAUNT_FAIL_ANNOUNCE_MESSAGE"],
			announceMisdiMessage = L["DEFAULT_MISDI_ANNOUNCE_MESSAGE"],

			-- Modes
			currentMode = nil, -- Will be set based on *modeButton flags at the end of this file
			tranqModeButton    = SilentRotate:isPlayerWanted("player", nil, 'hunterz'),
			loathebModeButton  = SilentRotate:isPlayerWanted("player", nil, 'healerz'),
			distractModeButton = SilentRotate:isPlayerWanted("player", nil, 'roguez'),
			razModeButton = false, -- SilentRotate:isPlayerWanted("player", nil, 'priestz'), -- Do not allow Razuvious mode for now
			fearWardModeButton = SilentRotate:isPlayerWanted("player", nil, 'fearz'),
			aoeTauntModeButton = SilentRotate:isPlayerWanted("player", nil, 'tauntz'),
			misdiModeButton    = (WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC) and SilentRotate:isPlayerWanted("player", nil, 'misdiz'),
			tranqModeText    = L["FILTER_SHOW_HUNTERS"],
			loathebModeText  = L["FILTER_SHOW_HEALERS"],
			distractModeText = L["FILTER_SHOW_ROGUES"],
			razModeText      = L["FILTER_SHOW_PRIESTS"],
			fearWardModeText = L["FILTER_SHOW_DWARVES"],
			aoeTauntModeText = L["FILTER_SHOW_AOETAUNTERS"],
			misdiModeText    = L["FILTER_SHOW_MISDIRECTORS"],

			-- Names
			useClassColor = true,
			useNameOutline = false,
			prependIndex = false,
			indexPrefixColor = {SilentRotate.colors.lightCyan:GetRGB()},
			appendGroup = false,
			groupSuffix = L["DEFAULT_GROUP_SUFFIX_MESSAGE"],
			groupSuffixColor = {SilentRotate.colors.lightCyan:GetRGB()},

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
 			showBlindIcon = true,
			showBlindIconTooltip = true,
		},
	
	}
	-- Find the default mode based on class compatibility
	if (self.defaults.profile.tranqModeButton and WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
		self.defaults.profile.currentMode = 'hunterz'
	elseif (self.defaults.profile.loathebModeButton) then
		self.defaults.profile.currentMode = 'healerz'
	elseif (self.defaults.profile.distractModeButton) then
		self.defaults.profile.currentMode = 'roguez'
	elseif (self.defaults.profile.fearWardModeButton) then
		self.defaults.profile.currentMode = 'fearz'
	elseif (self.defaults.profile.aoeTauntModeButton) then
		self.defaults.profile.currentMode = 'tauntz'
	elseif (self.defaults.profile.misdiModeButton) then
		self.defaults.profile.currentMode = 'misdiz'
	else
		-- Use Loatheb mode by default for classes who cannot fit other roles
		-- Also enable this option by default
		self.defaults.profile.tranqModeButton = true
		self.defaults.profile.currentMode = 'hunterz'
	end
end
