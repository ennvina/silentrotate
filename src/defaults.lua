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
		local assignAnnounce = function(isSuccess)
			-- isSuccess == true -> Success
			-- isSuccess == false -> Fail
			-- isSuccess == nil -> Timid Success
			local keyAddendum, translationAddendum, patternAddendum = "", "", "_SUCCESS"
			if type(isSuccess) == 'boolean' then
				if isSuccess then
					keyAddendum, translationAddendum = "Success", "_SUCCESS"
				else
					keyAddendum, translationAddendum, patternAddendum = "Fail", "_FAIL", "_FAIL"
				end
			end
			local key = "announce"..mode.modeNameFirstUpper..keyAddendum.."Message"
			local translation = "DEFAULT_"..mode.modeNameUpper..translationAddendum.."_ANNOUNCE_MESSAGE"
			if rawget(L, translation) then
				self.defaults.profile[key] = L[translation]
			else
				local modeFullNameKey = mode.modeNameUpper.."_MODE_FULL_NAME"
				local modeShortNameKey = "FILTER_SHOW_"..mode.modeNameUpper
				local modeName
				if rawget(L, modeFullNameKey) then
					modeName = L[modeFullNameKey]
				elseif rawget(L, modeShortNameKey) then
					modeName = L[modeShortNameKey]
				else
					modeName = mode.modeName
				end
				if type(isSuccess) == 'boolean' and not isSuccess then
					-- YELL the mode name for failures
					modeName = modeName:upper()
				end
				if mode.targetGUID then
					self.defaults.profile[key] = string.format(L["DEFAULT"..patternAddendum.."_PATTERN_WITHTARGET"], modeName)
				else
					self.defaults.profile[key] = string.format(L["DEFAULT"..patternAddendum.."_PATTERN_NOTARGET"], modeName)
				end
			end
		end
		-- Set config for announce messages
		if mode.canFail then
			assignAnnounce(true)
			assignAnnounce(false)
		else
			assignAnnounce(nil)
		end

		-- Set config for default visible modes
		local isModeButtonVisible = mode.project and mode.default
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
