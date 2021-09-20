local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

function SilentRotate:LoadDefaults()
	self.defaults = {
	    profile = {
			-- Messaging
	        enableAnnounces = true,
	        channelType = "YELL",
	        rotationReportChannelType = "RAID",
	        useMultilineRotationReport = false,

			-- Modes
			currentMode = nil, -- Will be set based on *modeButton flags at the end of this file

			-- Names
			useClassColor = true,
			useNameOutline = false,
			prependIndex = false,
			indexPrefixColor = {SilentRotate.colors.lightCyan:GetRGB()},
			appendGroup = false,
			appendTarget = true,
			appendTargetBuffOnly = true,
			appendTargetNoGroup = true,
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

	for modeName, mode in pairs(SilentRotate.modes) do
		-- Set config for announce messages
		if mode.canFail then
			self.defaults.profile["announce"..mode.modeNameFirstUpper.."SuccessMessage"] = L["DEFAULT_"..mode.modeNameUpper.."_SUCCESS_ANNOUNCE_MESSAGE"]
			self.defaults.profile["announce"..mode.modeNameFirstUpper.."FailMessage"] = L["DEFAULT_"..mode.modeNameUpper.."_FAIL_ANNOUNCE_MESSAGE"]
		else
			self.defaults.profile["announce"..mode.modeNameFirstUpper.."Message"] = L["DEFAULT_"..mode.modeNameUpper.."_ANNOUNCE_MESSAGE"]
		end

		-- Set config for default visible modes, based on compatibility with the player currently loading the addon
		local isModeButtonVisible = mode.project and SilentRotate:isPlayerWanted("player", nil, modeName)
		self.defaults.profile[modeName.."ModeButton"] = isModeButtonVisible

		-- Set config for the mode text
		self.defaults.profile[modeName.."ModeText"] = L["FILTER_SHOW_"..mode.modeNameUpper]

		-- The first mode button visible dictates the default mode
		if isModeButtonVisible and not self.defaults.profile.currentMode then
			self.defaults.profile.currentMode = modeName
		end
	end

	-- If no button is visible by default, pick one so that the player does not see an empty list
	if not not self.defaults.profile.currentMode then
		self.defaults.profile.tranqShotModeButton = true
		self.defaults.profile.currentMode = SilentRotate.modes.tranqShot.modeName
	end
end
