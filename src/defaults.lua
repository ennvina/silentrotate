local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

function SilentRotate:LoadDefaults()
	self.defaults = {
	    profile = {
			-- Main windows, at least one always exists
			windows = {
				{
					visible = true,
					width = 150,
				}
			},

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
			appendTargetBuffOnly = false,
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

			-- History
			history = {
				visible = false,
				width = 400,
				height = 200,
				messages = {},
			},
			historyTimeVisible = 600, -- 10 minutes
			historyFontSize = 12,

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
		local assignMessage = function(keyAddendum, translationAddendum)
			local key = "announce"..mode.modeNameFirstUpper..keyAddendum.."Message"
			local translation = "DEFAULT_"..mode.modeNameUpper..translationAddendum.."_MESSAGE"
			self.defaults.profile[key] = L[translation]
		end
		if mode.canFail then
			-- If mode can fail, register success and fail messages
			assignMessage("Success", "_SUCCESS_ANNOUNCE")
			assignMessage("Fail", "_FAIL_ANNOUNCE")
			if mode.alertWhenFail then
				assignMessage("React", "_REACTNOW_LOCAL")
			end
		else
			-- If mode cannot fail, register neutral message
			assignMessage("", "_ANNOUNCE")
		end

		-- Set config for default visible modes
		local isModeButtonVisible = mode.default
		self.defaults.profile[modeName.."ModeButton"] = isModeButtonVisible

		-- Set config for the mode text
		self.defaults.profile[modeName.."ModeText"] = L["FILTER_SHOW_"..mode.modeNameUpper]

		-- The first mode button visible dictates the default mode
		if isModeButtonVisible and not self.defaults.profile.currentMode then
			self.defaults.profile.currentMode = modeName
		end
	end

	-- If no button is visible by default, pick one so that the player does not see an empty list
	if not self.defaults.profile.currentMode then
		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
			self.defaults.profile.loathebModeButton = true
			self.defaults.profile.currentMode = SilentRotate.modes.loatheb.modeName
		else
			self.defaults.profile.misdiModeButton = true
			self.defaults.profile.currentMode = SilentRotate.modes.misdi.modeName
		end
	end
end
