SilentRotate = select(2, ...)

local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

local parent = ...
SilentRotate.version = GetAddOnMetadata(parent, "Version")

-- Initialize addon - Shouldn't be call more than once
function SilentRotate:init()

    self:LoadDefaults()

    self.db = LibStub:GetLibrary("AceDB-3.0"):New("SilentRotateDb", self.defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "ProfilesChanged")

    self:CreateConfig()

    SilentRotate.hunterTable = {}
    SilentRotate.addonVersions = {}
    SilentRotate.rotationTables = { rotation = {}, backup = {} }
    SilentRotate.enableDrag = true

    SilentRotate.raidInitialized = false
    SilentRotate.testMode = false

    SilentRotate:initGui()
    SilentRotate:loadHistory()
    SilentRotate:updateRaidStatus()
    SilentRotate:applySettings()

    SilentRotate:initComms()

    SilentRotate:printMessage(L['LOADED_MESSAGE'])
end

-- Apply setting on profile change
function SilentRotate:ProfilesChanged()
	self.db:RegisterDefaults(self.defaults)
    self:applySettings()
end

-- Apply position, size, and visibility
function applyWindowSettings(frame, windowConfig)
    frame:ClearAllPoints()
    if windowConfig.point then
        frame:SetPoint(windowConfig.point, UIParent, 'BOTTOMLEFT', windowConfig.x, windowConfig.y)
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
    if windowConfig.width then
        frame:SetWidth(windowConfig.width)
    end
    if windowConfig.height then
        frame:SetHeight(windowConfig.height)
    end
    if type(windowConfig.visible) == 'boolean' and not windowConfig.visible then
        frame:Hide()
    end

    local unlocked = not SilentRotate.db.profile.lock
    frame:EnableMouse(unlocked)
    frame:SetMovable(unlocked)
    for _, resizer in pairs(frame.resizers) do
        resizer:SetShown(unlocked)
    end
end

-- Apply settings
function SilentRotate:applySettings()
    local config = SilentRotate.db.profile

    for _, mainFrame in pairs(SilentRotate.mainFrames) do
        applyWindowSettings(mainFrame, config.windows[mainFrame.windowIndex])
    end

    applyWindowSettings(SilentRotate.historyFrame, config.history)
    SilentRotate:setHistoryTimeVisible(config.historyTimeVisible)

    SilentRotate:updateDisplay()
end

-- Print wrapper, just in case
function SilentRotate:printMessage(msg)
    print(msg)
end

-- Print message with colored prefix
function SilentRotate:printPrefixedMessage(msg)
    SilentRotate:printMessage(SilentRotate:colorText(SilentRotate.constants.printPrefix) .. msg)
end

-- Send a tranq annouce message to a given channel
function SilentRotate:sendAnnounceMessage(message, targetName)
    if SilentRotate.db.profile.enableAnnounces then
        SilentRotate:sendMessage(
            message,
            targetName,
            SilentRotate.db.profile.channelType,
            SilentRotate.db.profile.targetChannel
        )
    end
end

-- Send a rotation broadcast message
function SilentRotate:sendRotationSetupBroacastMessage(message)
    if SilentRotate.db.profile.enableAnnounces then
        SilentRotate:sendMessage(
            message,
            nil,
            SilentRotate.db.profile.rotationReportChannelType,
            SilentRotate.db.profile.setupBroadcastTargetChannel
        )
    end
end

-- Send a message to a given channel
function SilentRotate:sendMessage(message, targetName, channelType, targetChannel)
    local channelNumber
    if channelType == "CHANNEL" then
        channelNumber = GetChannelName(targetChannel)
    end
    if (targetName ~= nil) then
        message = string.format(message, targetName)
    end
    SendChatMessage(message, channelType, nil, channelNumber or targetChannel)
end

SLASH_SILENTROTATE1 = "/sr"
SLASH_SILENTROTATE2 = "/silentrotate"
SlashCmdList["SILENTROTATE"] = function(msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if (cmd == 'toggle') then
        SilentRotate:toggleDisplay()
    elseif (cmd == 'show') then
        SilentRotate:showDisplay()
    elseif (cmd == 'hide') then
        SilentRotate:hideDisplay()
    elseif (cmd == 'lock') then
        SilentRotate:lock(true)
    elseif (cmd == 'unlock') then
        SilentRotate:lock(false)
    elseif (cmd == 'rotate') then -- @todo decide if this should be removed or not
        SilentRotate:testRotation()
    elseif (cmd == 'test') then -- @todo: remove this
        SilentRotate:test()
    elseif (cmd == 'report') then
        SilentRotate:printRotationSetup()
    elseif (cmd == 'settings') then
        SilentRotate:toggleSettings()
    elseif (cmd == 'history') then
        SilentRotate:toggleHistory()
    elseif (cmd == 'check' or cmd== 'version') then
        SilentRotate:checkVersions()
    else
        SilentRotate:printHelp()
    end
end
--SlashCmdList["SR"] = SlashCmdList["SILENTROTATE"]

function SilentRotate:showDisplay()
    for _, mainFrame in pairs(SilentRotate.mainFrames) do
        if not mainFrame:IsShown() then
            mainFrame:Show()
            SilentRotate.db.profile.windows[mainFrame.windowIndex].visible = true
        end
    end
end

function SilentRotate:hideDisplay()
    for _, mainFrame in pairs(SilentRotate.mainFrames) do
        local somethingWasHidden = false
        if mainFrame:IsShown() then
            mainFrame:Hide()
            SilentRotate.db.profile.windows[mainFrame.windowIndex].visible = false
            somethingWasHidden = true
        end
        if somethingWasHidden then
            SilentRotate:printMessage(L['TRANQ_WINDOW_HIDDEN'])
        end
    end
end

-- If all main frames are hidden, show them all
-- Otherwise hide the frames that are visible
function SilentRotate:toggleDisplay()
    local everythingHidden = true
    for _, mainFrame in pairs(SilentRotate.mainFrames) do
        if mainFrame:IsShown() then
            everythingHidden = false
            break
        end
    end

    if everythingHidden then
        for _, mainFrame in pairs(SilentRotate.mainFrames) do
            mainFrame:Show()
            SilentRotate.db.profile.windows[mainFrame.windowIndex].visible = true
        end
    else 
        for _, mainFrame in pairs(SilentRotate.mainFrames) do
            if mainFrame:IsShown() then
                mainFrame:Hide()
                SilentRotate.db.profile.windows[mainFrame.windowIndex].visible = false
            end
        end
        SilentRotate:printMessage(L['TRANQ_WINDOW_HIDDEN'])
    end
end

function SilentRotate:toggleHistory()
    if SilentRotate.historyFrame:IsShown() then
        SilentRotate.historyFrame:Hide()
        SilentRotate.db.profile.history.visible = false
    else
        SilentRotate.historyFrame:Show()
        SilentRotate.db.profile.history.visible = true
    end
end

-- @todo: remove this
function SilentRotate:test()
    SilentRotate:printMessage('test')
    SilentRotate:toggleArcaneShotTesting()
end

-- Toggle Ace settings
function SilentRotate:toggleSettings()
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")
    local aceConfigAppName = "SilentRotate"
    if AceConfigDialog.OpenFrames[aceConfigAppName] then
        AceConfigDialog:Close(aceConfigAppName)
    else
        AceConfigDialog:Open(aceConfigAppName)
    end
end

-- Sends rotation setup to raid channel
function SilentRotate:printRotationSetup()

    if (IsInRaid() or SilentRotate.testMode) then
        SilentRotate:sendRotationSetupBroacastMessage('--- ' .. SilentRotate.constants.printPrefix .. SilentRotate:getBroadcastHeaderText() .. ' ---', channel)

        if (SilentRotate.db.profile.useMultilineRotationReport) then
            SilentRotate:printMultilineRotation(SilentRotate.rotationTables.rotation)
        else
            SilentRotate:sendRotationSetupBroacastMessage(
                SilentRotate:buildGroupMessage(L['BROADCAST_ROTATION_PREFIX'] .. ' : ', SilentRotate.rotationTables.rotation)
            )
        end

        if (#SilentRotate.rotationTables.backup > 0) then
            SilentRotate:sendRotationSetupBroacastMessage(
                SilentRotate:buildGroupMessage(L['BROADCAST_BACKUP_PREFIX'] .. ' : ', SilentRotate.rotationTables.backup)
            )
        end
    end
end

-- Print the main rotation on multiple lines
function SilentRotate:printMultilineRotation(rotationTable, channel)
    local position = 1;
    for key, hunt in pairs(rotationTable) do
        SilentRotate:sendRotationSetupBroacastMessage(tostring(position) .. ' - ' .. hunt.name)
        position = position + 1;
    end
end

-- Serialize hunters names of a given rotation group
function SilentRotate:buildGroupMessage(prefix, rotationTable)
    local hunters = {}

    for key, hunt in pairs(rotationTable) do
        table.insert(hunters, hunt.name)
    end

    return prefix .. table.concat(hunters, ', ')
end

-- Print command options to chat
function SilentRotate:printHelp()
    local spacing = '   '
    SilentRotate:printMessage(SilentRotate:colorText('/silentrotate') .. ' commands options :')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('toggle') .. ' : Show/Hide the main window')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('settings') .. ' : Show/hide SilentRotate settings')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('history') .. ' : Show/hide history window')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('lock') .. ' : Lock the main window position')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('unlock') .. ' : Unlock the main window position')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('report') .. ' : Print the rotation setup to the configured channel')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('check') .. ' : Print user versions of SilentRotate')
end

-- Adds color to given text
function SilentRotate:colorText(text)
    return '|cffffbf00' .. text .. '|r'
end

-- Check if unit is promoted
function SilentRotate:isHunterPromoted(name)

    local raidIndex = UnitInRaid(name)

    if (raidIndex) then
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(raidIndex)

        if (rank > 0) then
            return true
        end
    end

    return false
end

-- Toggle arcane shot testing mode
function SilentRotate:toggleArcaneShotTesting(disable)

    if (not disable and not SilentRotate.testMode) then
        SilentRotate:printPrefixedMessage(L['ARCANE_SHOT_TESTING_ENABLED'])
        SilentRotate.testMode = true

        -- Disable testing after 60 minutes
        C_Timer.After(3600, function()
            SilentRotate:toggleArcaneShotTesting(true)
        end)
    else
        SilentRotate.testMode = false
        SilentRotate:printPrefixedMessage(L['ARCANE_SHOT_TESTING_DISABLED'])
    end

    SilentRotate:updateRaidStatus()
end

function SilentRotate:updatePlayerAddonVersion(player, version)

    local hunter = SilentRotate:getHunter(player)
    if (hunter) then
        hunter.addonVersion = version
        SilentRotate:updateBlindIcon(hunter)
    else
        SilentRotate.addonVersions[player] = version
    end

    local updateRequired, breakingUpdate = SilentRotate:isUpdateRequired(version)
    if (updateRequired) then
        SilentRotate:notifyUserAboutAvailableUpdate(breakingUpdate)
    end
end

function SilentRotate:checkVersions()
    SilentRotate:printPrefixedMessage("## Version check ##")
    SilentRotate:printPrefixedMessage("You - " .. SilentRotate.version)

    for key, hunter in pairs(SilentRotate.hunterTable) do
        if (hunter.name ~= UnitName("player")) then
            SilentRotate:printPrefixedMessage(hunter.name .. " - " .. SilentRotate:formatAddonVersion(hunter.addonVersion))
        end
    end
    for key, player in pairs(SilentRotate.addonVersions) do
        if (player ~= UnitName("player")) then
            SilentRotate:printPrefixedMessage(hunter.name .. " - " .. SilentRotate:formatAddonVersion(hunter.addonVersion))
        end
    end
end

function SilentRotate:formatAddonVersion(version)
    if (version == nil) then
        return "Not installed or older than 0.7.0"
    else
        return version
    end
end

-- Parse version string
-- @return major, minor, fix, isStable
function SilentRotate:parseVersionString(versionString)

    local version, type = strsplit("-", versionString)
    local major, minor, fix = strsplit( ".", version)

    return tonumber(major), tonumber(minor), tonumber(fix), type == nil
end

-- Check if the given version would require updating
-- @return requireUpdate, breakingUpdate
function SilentRotate:isUpdateRequired(versionString)

    local remoteMajor, remoteMinor, remoteFix, isRemoteStable = self:parseVersionString(versionString)
    local localMajor, localMinor, localFix, isLocalStable = self:parseVersionString(SilentRotate.version)

    if (isRemoteStable) then

        if (remoteMajor > localMajor) then
            return true, true
        elseif (remoteMajor < localMajor) then
            return false, false
        end

        if (remoteMinor > localMinor) then
            return true, false
        elseif (remoteMinor < localMinor) then
            return false, false
        end

        if (remoteFix > localFix) then
            return true, false
        end
    end

    return false, false
end

-- Notify user about a new version available
function SilentRotate:notifyUserAboutAvailableUpdate(isBreakingUpdate)
    if (isBreakingUpdate) then
        if (SilentRotate.notifiedBreakingUpdate ~= true) then
            SilentRotate:printPrefixedMessage('|cffff3d3d' .. L['BREAKING_UPDATE_AVAILABLE'] .. '|r')
            SilentRotate.notifiedBreakingUpdate = true
        end
    else
        if (SilentRotate.notifiedUpdate ~= true and SilentRotate.notifiedBreakingUpdate ~= true) then
            SilentRotate:printPrefixedMessage(L['UPDATE_AVAILABLE'])
            SilentRotate.notifiedUpdate = true
        end
    end
end